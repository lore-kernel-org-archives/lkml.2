Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab2AQCr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:47:29 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42960 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2AQCrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:47:25 -0500
Message-ID: <4F14DED7.3030002@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 10:37:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EEC5.8050807@linux.vnet.ibm.com> <CAJSP0QVxR9sYYh_Vr6ZKAU-YrWpjgL5jpiKz2zt7eJxV_kgaOg@mail.gmail.com>
In-Reply-To: <CAJSP0QVxR9sYYh_Vr6ZKAU-YrWpjgL5jpiKz2zt7eJxV_kgaOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12011702-9574-0000-0000-000000F8D11A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 06:08 PM, Stefan Hajnoczi wrote:

> On Mon, Jan 16, 2012 at 9:32 AM, Xiao Guangrong
> <xiaoguangrong@linux.vnet.ibm.com> wrote:
>> +DESCRIPTION
>> +-----------
>> +You can analyze some crucial events and statistics with this
>> +'perf kvm-events' command.
> 
> This line is very general and does not explain which events/statistics
> can be collected or how you can use that information.  I suggest
> making this description more specific.  Explain that this subcommand
> observers kvm.ko tracepoints and annotates/decodes them with
> additional information (this is why I would use this command and not
> raw perf record -e kvm:\*).
> 


Okay.

>> + � � � { SVM_EXIT_MONITOR, � � � � � � � � � � "monitor" }, \
>> + � � � { SVM_EXIT_MWAIT, � � � � � � � � � � � "mwait" }, \
>> + � � � { SVM_EXIT_XSETBV, � � � � � � � � � � �"xsetbv" }, \
>> + � � � { SVM_EXIT_NPF, � � � � � � � � � � � � "npf" }
> 
> All this copy-paste could be avoided by sharing this stuff with the
> arch/x86/kvm/ code.
> 


I will try to combine them in the next version.

>> +static void exit_event_decode_key(struct event_key *key, char decode[20])
>> +{
>> + � � � const char *exit_reason = get_exit_reason(key->info, key->key);
>> +
>> + � � � memset(decode, 0, 20);
>> + � � � strncpy(decode, exit_reason, 20);
> 
> This is a bad pattern to follow when using strncpy(3) because if there
> was a strlen(exit_reason) == 20 string then decode[] would not be
> NUL-terminated.  Right now it's safe but it's better to just use
> strlcpy() and drop the memset(3).
> 


Good point.

>> +static void mmio_event_decode_key(struct event_key *key, char decode[20])
>> +{
>> + � � � memset(decode, 0, 20);
>> + � � � sprintf(decode, "%#lx:%s", key->key,
>> + � � � � � � � key->info == KVM_TRACE_MMIO_READ ? "R" : "W");
> 
> Please drop the memset and use snprintf(3) instead of sprintf(3).  It
> places the NUL-terminator and ensures you don't exceed the buffer
> size.
> 
> Same pattern below.
> 


Will do, thanks Stefan! :)




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab1DHVMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:12:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46261 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1DHVMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x1eCRF51uDN9urDOHrWxea6uMpEOg4jcPqSR6nZ/Rg3Pe49+zqkLnMpFeYzMB6VhBi
         WndyVvBNbFIzY3npavG5Y9dCyjVcJwgVQhOILokplnHsL5PKJGQ7KZ7bVDAJS8g3EE+e
         0NVlUfPxGexD5hBnpGYTlHSQsMGExR9Dn1R3g=
Message-ID: <4D9F7A4B.3040606@gmail.com>
Date: Fri, 08 Apr 2011 15:12:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: Re: trace-cmd errors on kvm events
References: <4D9F59AC.6080707@gmail.com> <4D9F790B.2000300@web.de>
In-Reply-To: <4D9F790B.2000300@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/08/11 15:07, Jan Kiszka wrote:
> On 2011-04-08 20:53, David Ahern wrote:
>> 2.6.38.2 kernel with trace-cmd git pulled this morning:
>>
>> trace-cmd record -e kvm
>>
>> trace-cmd report 2>&1 | less
>>
>> trace-cmd: No such file or directory
> 
> Does this error come from trace-cmd failing to find its kvm plugin?
> Check what strace -e open says.
> 
> Jan
> 

Tried that before - it was not enlightening.
strace -e trace=open trace-cmd report 2>&1 | less

open("/etc/ld.so.cache", O_RDONLY)      = 3
open("/lib64/libdl.so.2", O_RDONLY)     = 3
open("/lib64/libc.so.6", O_RDONLY)      = 3
open("/root/trace.dat", O_RDONLY)       = 3
trace-cmd: No such file or directory
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_nested_vmexit_inject
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_nested_vmexit
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_exit
  bad op token {
  failed to read event print fmt for kvm_emulate_insn
open("/proc/meminfo", O_RDONLY)         = 4

David

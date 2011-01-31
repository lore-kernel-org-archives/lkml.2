Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1AaTzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:55:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36236 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1AaTzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d4Xyqw19BswooW2mMZGTi73SVH0ljZkPnLtKIF/NDNjH+Ew+h/jwVeQCJYGoZ6G4EO
         IaDAHAo4yogo27eg1p79s28CSy1eEayYO589YnRgDPpTNS2z4BK6oKXXGeGE1/daD3sA
         9I7qBFEb5l6EScBMq6TsAsmKvK1ATavCdSMeo=
MIME-Version: 1.0
In-Reply-To: <20110131155330.GL7459@htj.dyndns.org>
References: <1295789862-25482-14-git-send-email-tj@kernel.org>
	<tip-bbc9e2f452d9c4b166d1f9a78d941d80173312fe@git.kernel.org>
	<4D4327FC.5000600@kernel.org>
	<20110131155330.GL7459@htj.dyndns.org>
Date: Mon, 31 Jan 2011 11:55:22 -0800
X-Google-Sender-Auth: obwVqWWQdBESJCVCXeg2gc0q1Rk
Message-ID: <AANLkTikfLF55g2MoicWvsOnStT98q2bj5M+LnwiyPhti@mail.gmail.com>
Subject: Re: [tip:x86/numa] x86: Unify cpu/apicid <-> NUMA node mapping
 between 32 and 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, tglx@linutronix.de, rientjes@google.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 7:53 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Yinghai.
>
> On Fri, Jan 28, 2011 at 12:33:00PM -0800, Yinghai Lu wrote:
>> > +#ifdef CONFIG_NUMA
>> > +extern int __cpuinit numa_cpu_node(int apicid);
>>
>> cpu or apicid?
>
> Should have been @cpu.  Will send a patch to update it.
>
>> > +int __cpuinit numa_cpu_node(int cpu)
>> > +{
>> > +   int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
>> > +
>> > +   if (apicid != BAD_APICID)
>> > +           return __apicid_to_node[apicid];
>> > +   return NUMA_NO_NODE;
>> > +}
>>
>> it should be changed to cpu_to_node_via_apicid(), it could return
>> not onlined node, aka node without memory.
>>
>> So don't mess it up with cpu_to_node()
>
> Hmmm... are you saying that the name is too confusing with
> cpu_to_node() and should be renamed to cpu_to_node_via_apicid()?  In
> that case, I agree but wish the name were something which represents
> what it does as _via_apicid postfix doesn't really tell much.  Any
> better idea?

yes.

wonder if there is other good name better than cpu_to_node_via_apicid...

Yinghai

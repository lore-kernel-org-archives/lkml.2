Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1HOGZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:25:09 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54021 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1HOGZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:25:06 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CAM_iQpXRQ8C=y=DUt2pW_wQ_WKZU+2=ZBsGSPA2qmVATkTEQpA@mail.gmail.com>
References: <CAC4B8726E86A142B27A9E9A2F2F124701922F2855@rrsmsx505.amr.corp.intel.com>
	<4E3BE686.7070501@mit.edu>
	<CAM_iQpXRQ8C=y=DUt2pW_wQ_WKZU+2=ZBsGSPA2qmVATkTEQpA@mail.gmail.com>
Date: Mon, 15 Aug 2011 09:25:03 +0300
Message-ID: <CAOtvUMdok1Hc63FbiPu-rm2EJxpDtLOf2ZWPhsqa=m0tr8TyVw@mail.gmail.com>
Subject: Re: Is there a way to offload everything from cpu0 to other cpus?
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Andy Lutomirski <luto@mit.edu>, "Yung, Winson W" <winson.w.yung@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 12:41 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Aug 5, 2011 at 8:48 PM, Andy Lutomirski <luto@mit.edu> wrote:
>> On 08/04/2011 10:53 PM, Yung, Winson W wrote:
>>>
>>> Hi, I would like to know whether it is possible to offload everything
>>> (kernel threads/user apps) to cpu1...x so that I can force cpu0 go into
>>> idle?

...
>>
>> You probably want the isolcpus boot option.
>
> I think Yung was looking for an interface to move tasks dynamically
> after the system is boot.
>
> Yung, why /sys/devices/system/cpu/cpuX/online doesn't work for you?

I believe setting up a cpuset for cpus 1 to x (call it the system set)
and a seperate cpuset for cpu 0 (call it the shielded set) and
re-assigning all non CPU bound kernel tasks from the root cpuset to
the system cpu set is a better option.

There's a guide on how to do that on the RT wiki:
https://rt.wiki.kernel.org/index.php/CPU_shielding_using_/proc_and_/dev/cpuset

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com
"Dance like no one is watching, love like you'll never be hurt, sing
like no one is listening... but for BEEP sake you better code like
you're going to maintain it for years!"

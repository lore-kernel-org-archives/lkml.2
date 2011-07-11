Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1GKLr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:47:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab1GKLr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:47:26 -0400
Message-ID: <4E1AE2CC.4010501@suse.de>
Date: Mon, 11 Jul 2011 13:47:24 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        jcm@redhat.com, dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com,
        stefanr@s5r6.in-berlin.de
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp> <20110708145408.GA2283@kroah.com> <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com> <20110708154736.GA7320@kroah.com> <1310140451.3282.85.camel@mulgrave> <CAPXgP12dA72a3ja659GH6uW+ZCMfL6iECaY6ORXwOQ6S5eTvaQ@mail.gmail.com> <CAPXgP11aTKVvrT++_FyZqd8YTzgbRmouUv1iGWfnZsoepQCspg@mail.gmail.com>
In-Reply-To: <CAPXgP11aTKVvrT++_FyZqd8YTzgbRmouUv1iGWfnZsoepQCspg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2011 06:38 PM, Kay Sievers wrote:
> On Fri, Jul 8, 2011 at 18:15, Kay Sievers<kay.sievers@vrfy.org>  wrote:
>> On Fri, Jul 8, 2011 at 17:54, James Bottomley
>
>>> But hey,
>>> you have the enthusiasm, propose it as a KS topic to get agreement that
>>> we should do it and what the format should be and we can go from there.
>>
>> Sure, I'll do that. If needed, I can even make half or a third of it
>> possible I guess.
>
> Submitted it a minute ago.
>
I'd be willing to working on the design here, as it ties in rather 
neatly with my goal of updating the SCSI debugging facilities.

printk() is easy to write, but basically impossible to impose any 
type of checking/format whatever.
My all-time favorite here:

                 printk(KERN_INFO "error 1\n");

At least it got a 'KERN_INFO' thrown in there ...

So first step would be to reach an agreement _what_ printk() et al 
is supposed to convey to userland.
Informal only? Informal, but traceable to the origin?
Should the origin be the internal 
structure/subsystem/device/whatever generating the error?
Should the origin be persistent across reboots?

And, tied to that, what the supposed audience for printk() is:
Programs? Syslog? Humans?

Once we have an agreement here we can then go about and code the 
required pieces. But currently the main problem is that there are 
different ideas of what printk() is supposed to do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

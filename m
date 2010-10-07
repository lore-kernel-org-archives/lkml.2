Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0JGVdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:33:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54051 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab0JGVdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=sT4z8LzNoKi4q4Kfy2Hm0EgXm7u2OJKda6GluMrdzh10teoa2+9Jcu4rHil6FuddZD
         YgEmVv5lCiy1FhpHw9FC9Ie7zZcvsCHNyF0X1CJ3Hz59Tb99AsHKdgBejNRkLrYhHi8H
         6sJPShQoheCFNgZB8VCI9VgKqPzLJgqgVbj94=
MIME-Version: 1.0
In-Reply-To: <1286486274.23836.62.camel@c-dwalke-linux.qualcomm.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
 <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com> <AANLkTi=8Et=Z6zrzbZa3L0MO=cBjjh7L=XU2=PDEbzWW@mail.gmail.com>
 <1286481532.23836.27.camel@c-dwalke-linux.qualcomm.com> <AANLkTi=j2n-X+-zkas8HdL1awo7Lcyxwofts6FjU8vj6@mail.gmail.com>
 <1286482013.23836.29.camel@c-dwalke-linux.qualcomm.com> <AANLkTinDvL9vPb6nmve3rO9dMtMAqh=d1oqBVTOHzYWH@mail.gmail.com>
 <1286485186.23836.56.camel@c-dwalke-linux.qualcomm.com> <AANLkTi==_WDX03gYRa0=qCSgZ2eoO-Uzpg66WeEX57rS@mail.gmail.com>
 <1286486274.23836.62.camel@c-dwalke-linux.qualcomm.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 7 Oct 2010 17:32:53 -0400
X-Google-Sender-Auth: Qofz9xxYBDZ884FhdKMCV4BxrKw
Message-ID: <AANLkTimPrvj=NkJ0eN5kAmRTNof1N2nfo4U-THRnqikF@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 17:17, Daniel Walker wrote:
> On Thu, 2010-10-07 at 17:05 -0400, Mike Frysinger wrote:
>> On Thu, Oct 7, 2010 at 16:59, Daniel Walker wrote:
>> > On Thu, 2010-10-07 at 16:47 -0400, Mike Frysinger wrote:
>> >> On Thu, Oct 7, 2010 at 16:06, Daniel Walker wrote:
>> >> > On Thu, 2010-10-07 at 16:02 -0400, Mike Frysinger wrote:
>> >> >> how is that any different from:
>> >> >> ln -s ttyJ0 /dev/ttyS0
>> >> >
>> >> > It has the same major and minors as ttyS* does. So you don't have to run
>> >> > anything on the target.
>> >>
>> >> i dont see how those things are related.  the major/minor are
>> >> irrelevant, unless you've already hard coded these in some app that
>> >> creates device nodes manually (instead of mdev/udev), but even then
>> >> that's something that "needs to be run on the target".  and both
>> >> already have config support to transparently do something like
>> >> "symlink ttyS# to XXX" as XXX is created.
>> >
>> > Something does ultimately run on all targets, the issues is does the
>> > person debugging have the ability to change it .. It's not always the
>> > case that they can change it. The userspace may not have udev at all.
>> > The userspace may consist of a single binary .. I'm not making any
>> > assumptions about the userspace here, it can be anything.
>>
>> then there is already a static rootfs with pre-populated /dev which
>> would be fixed, or the single binary fixed.  if the options are "my
>> system works" or "my system doesnt work", i cant imagine people would
>> continue to attempt to use "/dev/ttyS#" if it didnt exist or didnt
>> work.
>
> Ideally you would want this driver to work in any situation .. If it's
> setup to use ttyS0 for debugging, even if it doesn't exist, then this
> driver would be able to stand in for that interface.

i dont think that's the case.  "any situation" is way too vague and
invites mounds of crap to be included in the kernel which really
should be in userspace.  ive never had a problem with my embedded work
using ttyBF# or ttyBFJC# or ttySS# for the Blackfin serial devices,
nor have i heard customers complain that the file absolutely must be
named "ttyS#".  ive found that simply informing them "to use ttyBF#"
has always been sufficient.
-mike

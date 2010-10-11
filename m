Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0JKRyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:54:52 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:53702 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680Ab0JKRyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:54:51 -0400
Message-ID: <4CB34F53.6080409@euromail.se>
Date: Mon, 11 Oct 2010 19:54:27 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chris Bagwell <chris@cnpbagwell.com>
CC: Takashi Iwai <tiwai@suse.de>, Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, xorg-devel@lists.x.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: Re: [PATCH 3/3] Input: synaptics - remove touches over button click
 area
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>	<1286549880-32580-2-git-send-email-chase.douglas@canonical.com>	<1286549880-32580-3-git-send-email-chase.douglas@canonical.com>	<1286549880-32580-4-git-send-email-chase.douglas@canonical.com>	<AANLkTi=QA5zgn=u39RyordViWw1CgpK9gy8kE_MdrpN3@mail.gmail.com>	<s5h7hho3bau.wl%tiwai@suse.de> <AANLkTi=G3xYm5+Wqv0quGGUhDEd7x8r7WJhN-tb6G=TA@mail.gmail.com>
In-Reply-To: <AANLkTi=G3xYm5+Wqv0quGGUhDEd7x8r7WJhN-tb6G=TA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P5MZy-0007Jx-4G.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1P5MZy-0007Jx-4G 96a95045951dc0f5fdc382a75bbda5ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 07:46 PM, Chris Bagwell wrote:
[...]

>>> I'm convinced now that clickpad style touchpads can't work without
>>> multi-touch and something like logic in xf86-input-multitouch.
>>
>> Actually Clickpad works without multi-touch patch.  With my patches to
>> synaptics, it worked in some level.  There are many restrictions (e.g.
>> pushing the button first then drag), though.
>>
> 
> True, but if I understand synaptic hardware MT behavior (sends
> actively moving finger in higher resolution packet regardless of
> original finger touch) then your patch will result in jumpy cursor on
> X side and that side would need patches to attempt to guess invalid
> data and discard.  I've worked on a few similar patches to various
> xf86-input-* and generally they've failed to detect difference between
> invalid packets vs. fast user movements.
> 
> The main point of my 3 options was to address jumpy cursor in
> xf86-input-* that are not MT aware.  I think ABS_X/ABS_Y should only
> allow its meaning to change at detectable time periods so user can
> account for it and, specifically, that time period is best at
> transition of BTN_TOOL_DOUBLETAP.
> 
> Assuming its easy enough to support exact rules for ABS_X/ABS_Y
> changing meanings on kernel side (which I think it probably is pretty
> easy), I think we should do it so that applications don't have to
> become MT-aware as the official solution for jumpy cursors.


A solution like the one you describe was actually proposed and agreed upon in
the beginning of this thread, so I think the only thing left to do is actually
write the patch. :-) I can only assume that Takashi or Chase will be back in a
bit with an update.

Cheers,
Henrik

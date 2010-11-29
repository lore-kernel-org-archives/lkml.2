Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0K2Bg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:36:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40060 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab0K2Bg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:36:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=ET/bP13TH+ACPdYxSR3i0SR/dnqSWWC2BUJ+jL/tMkCHBx8yF+AaftCCiLprYuDUT6
         h8cZ4EIytnjZbcwvXkQOyQ9jOaVAtg2Yok0OaH62IvghWJiOCGJ76ozHS5OSVuRD28mq
         VEi/4nPIvQ3z2F3S+cxoD+F1jRrD8gOHlP2hk=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=2O80uDo4DvjVj14Q0DGqTcZMQmnd-q2XV6f4K@mail.gmail.com>
References: <AANLkTimjMR4wUYCfi7BoUcg6aBmuWcQW_dBo8svReWcS@mail.gmail.com>
	<201011281621.59036.maciej.rutecki@gmail.com>
	<AANLkTi=2O80uDo4DvjVj14Q0DGqTcZMQmnd-q2XV6f4K@mail.gmail.com>
Date: Mon, 29 Nov 2010 03:36:55 +0200
Message-ID: <AANLkTikCt+OB6bq-7Kam40uo=-8Nt-fTa-_o0h835kkN@mail.gmail.com>
Subject: Re: 2.6.37-rc3-git4 bad desktop performance
From: Anca Emanuel <anca.emanuel@gmail.com>
To: maciej.rutecki@gmail.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 6:51 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> On Sun, Nov 28, 2010 at 5:21 PM, Maciej Rutecki
> <maciej.rutecki@gmail.com> wrote:
>> On niedziela, 28 listopada 2010 o 13:21:24 Anca Emanuel wrote:
>>> Linus,
>>>
>>> Last known good kernel: 2.6.37-rc3
>>> Driver: nouveau
>>> Test: play a HD movie.
>>
>> I created a Bugzilla entry at
>> https://bugzilla.kernel.org/show_bug.cgi?id=23912
>> for your bug report, please add your address to the CC list in there, thanks!
>>
>> PS. Please, send config, dmesg, do bisection etc. will be useful...
>
> config and dmesg attached.
> Bisecting now, but it will take some time.

linux-2.6$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[241b652f1995de138106afd2f2e4eda9f8a3c240] xhci: Remove excessive
printks with shared IRQs.

I don't think that is relevant, sorry.

git bisect log
git bisect start
# bad: [0f639a3c5ca63dd76ee07de9b02ebf0178ce9a17] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad 0f639a3c5ca63dd76ee07de9b02ebf0178ce9a17
# good: [3561d43fd289f590fdae672e5eb831b8d5cf0bf6] Linux 2.6.37-rc3
git bisect good 3561d43fd289f590fdae672e5eb831b8d5cf0bf6
# bad: [e5fa506173a6ed1ca8d78ba1e390cfdebc2fd49a] Merge branch
'fbdev-fixes-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6
git bisect bad e5fa506173a6ed1ca8d78ba1e390cfdebc2fd49a
# bad: [ea49b1669b7b405e0eb0bf877c7b7fb01f8dd19b] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad ea49b1669b7b405e0eb0bf877c7b7fb01f8dd19b
# bad: [a4ec046c98283d9f36817589081e14850570739f] Merge branch
'upstream/for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen
git bisect bad a4ec046c98283d9f36817589081e14850570739f
# bad: [3cbaa0f7a78d3b970b566629ee298c310780b919] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git bisect bad 3cbaa0f7a78d3b970b566629ee298c310780b919
# bad: [3d091a6f703906c5680855ff29bd94d051c8c6d8] USB: EHCI: AMD
periodic frame list table quirk
git bisect bad 3d091a6f703906c5680855ff29bd94d051c8c6d8
# bad: [723b991a62d94f74c9f19abd3da6e937288eb969] USB: ehci: fix
debugfs 'lpm' permissions
git bisect bad 723b991a62d94f74c9f19abd3da6e937288eb969
# bad: [dc07c91b9b4067022210e68d914a6890a4d70622] xHCI: fix wMaxPacketSize mask
git bisect bad dc07c91b9b4067022210e68d914a6890a4d70622
# bad: [74bb844af8ec6a4c360b1fc7feb139801c0cacfd] xHCI: release
spinlock when setup interrupt
git bisect bad 74bb844af8ec6a4c360b1fc7feb139801c0cacfd

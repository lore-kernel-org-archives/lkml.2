Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab0HDMRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:17:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab0HDMRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:17:40 -0400
Message-ID: <4C595B34.2010001@ontolinux.com>
Date: Wed, 04 Aug 2010 14:21:08 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: Kees Cook <kees.cook@canonical.com>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Al Viro <viro@ftp.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802122421.GA12130@infradead.org> <20100802165936.GV3948@outflux.net> <15424.1280775073@localhost> <20100803165010.GG3948@outflux.net> <78690.1280871500@localhost> <201008040354.o743sWTv078792@www262.sakura.ne.jp>
In-Reply-To: <201008040354.o743sWTv078792@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:ATCdqRr7vusSSXEYjDJEFIH7edNkaGtYtVZLaPCirmG
 3CNl0loQZ/uI5bXKAPN218YfcZTwepJoYTRath3MXgrfcqypfZ
 jU6hybum9aEbmN/LYTizSxEpU1M2p7DVvbaCXakny4dMeXzxLM
 HCjB3pfrQPnddx3bqqprGHSP+hwv+ueHDmtUctQiz1VZk64qq8
 swhtVoIInr41iMXyW5BIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aloha Testsu; Aloha Everybody;
On the 04.08.2010 05:54, Tetsuo Handa wrote :
> Valdis.Kletnieks@vt.edu wrote:
>   
>> That's why you need an actual model, not ad-hoc rules.  Start with "This program
>> has data we don't want leaked, by ptrace or any other means".  Work from there.
>>     
> /usr/sbin/sshd deals data (e.g. the content of /etc/shadow) which we don't want
> leaked, by ptrace or any other means.
>
> Please execute below commands on a system protected by SELinux, provided that
> permissions to execute below commands are given.
>
> # killall -KILL sshd
> # /usr/sbin/sshd -o 'Banner /etc/shadow'
> # ssh localhost
>
> The person who manages SELinux's policy believes that /etc/shadow is not leaked
> by the root user (e.g. "cat /etc/shadow" piped to "mail" command). But the root
> user can be different from the person who manages SELinux's policy (it can be a
> non-root user executing above commands using "sudo" command).
>
>   
>> But scribbling on /etc/passwd by using any of the 4,394 different known attacks
>> against Linux except the 1 that Yama protects against isn't considered a
>> problem.
>>     
> Leaking the content of /etc/shadow by using "banner" option isn't considered a
> problem, is it? What SELinux developers think "security" is not always same as
> what Linux users and non SELinux developers think.
>
> An app is dealing credit card information which we don't want leaked, by ptrace
> or any other means. But that app needs to send mail in order to report results.
> Who can prove that SELinux prevents that app from leaking credit card
> information while keeping that app working? Nobody can.
>   

I don't think that the job of SELinux is the protection on the
application level, but on the operating system level.

> SELinux is good at dealing read/write/execute permission and is a good solution
> for isolating information. But SELinux is not a perfect solution for controlling
> how the information is used (in other words, for what purpose the information
> is used). I can't believe in "information flow control" or BLP model because
> information itself cannot be labeled. Expecting LSM modules to guarantee "Data
> dealt by this program is never leaked, by ptrace or any other means" sounds an
> illusion for me.
>
> TOMOYO is less good at dealing read/write/execute permission but is better at
> dealing parameters (e.g. filename, command line arguments, environment
> variables, DAC mode) that affect how the information is used. Although, TOMOYO
> does not make any guarantee like BLP model, TOMOYO is addressing problems which
> SELinux is not addressing.
>
>   
>> It will likely not be accepted as an in-tree LSM, especially given that currently
>> it's rather difficult to stack two LSM's - which means that if a site wants to
>> run Yama, it becomes unable to take advantage of all the *other* security
>> features of SELinux or something similar.  In other words - if you want to be
>> an LSM, you need to be full-featured enough to cover all the bases, not just
>> a few cherry-picked ones.
>>     
> If a site wants to run TOMOYO, it becomes unable to take advantage of SELinux.
> No LSM module is full-featured enough to cover all the bases. TOMOYO was
> accepted as an in-tree LSM nonetheless TOMOYO is covering only a few
> cherry-picked ones.
>   

That's why I argued that the Yama LSM can exist, but with own concepts
and methodes and not as a container for throwning in ad-hoc rules taken
from other security packages (if there exist other ways to get the
functionalities/features), please.

> I don't have a plan to make TOMOYO cover all the bases by reinventing what
> SELinux/Smack already does. Rather, I want to stack/chain LSM modules so that
> TOMOYO can be used with SELinux/Smack/AppArmor/Yama.
>
> I'm not happy to keep Yama out-of-tree because of "Yama covers only a few
> cherry-picked ones" and "LSM is not stackable/chainable".
> I believe LSM should become stackable/chainable.
>   

So that would mean a change of the LSM architecture to make it stackable
and in an additional step it could be changed that other security
packages that are no LSMs (grsecurity/Openwall/RSBAC/...) can become as
a whole an LSM and stackable/chainable so that they don't have to be
reinvented, or let us better say imported, by the Yama LSM. But this
would mean as well that then the actual Yama LSM is obsolete.

Have fun
Christian Stroetmann

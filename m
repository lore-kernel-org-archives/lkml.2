Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0FSXP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 19:15:56 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:51558 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0FSXPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 19:15:55 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4C1D4FA6.6030607@tudelft.nl>
Date: Sun, 20 Jun 2010 01:15:50 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100614 Mandriva/3.0.4-11mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Regression 2.6.35-rc1?] Sysrq works too well (no need of alt)
References: <4C0E0E51.8050709@tudelft.nl> <201006192316.32360.rjw@sisk.pl>
In-Reply-To: <201006192316.32360.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 19-06-10 23:16, Rafael J. Wysocki schreef:
> On Tuesday, June 08, 2010, Éric Piel wrote:
>> Hello,
>> I haven't investigated much yet, but I have the feeling that since
>> 2.6.35-rc1 my "Print Screen/SysRq" key works only as SysRq: if I press
>> it (normally assigned to take screenshot in gnome), nothing happens (no
>> input event received in userspace) and no key on the keyboard works
>> afterwards, until I press Alt. Actually the keys work, but behave as if
>> the sysrq key was kept pressed (can be seen in dmesg, or by pressing "b").
>>
>> Looking at the log, a potential culprit is commit
>> 97f5f0cd8cd0a05449cbb77d1e6f02e026875802 (Input: implement SysRq as a
>> separate input handler). Probably the logic of "have to press all the
>> keys at the same time" changed to "have to press the keys one after each
>> other". So pressing alt and later on pressing PrintScreen leads to a SysRq.
>>
>> Does anybody else see this behaviour? Any suggestion on how to solve
>> this bug? I'll try reverting the commit and report if it fixes the
>> problem (the git revert fails so I've got to fix the conflict manually).
> 
> Is this still a problem with 2.6.35-rc3?
The bug is still in 2.6.35-rc3. The patch that fixes this regression is
in the "for-linus" branch of the input tree, but I think Dmitry hasn't
yet sent a pull request to Linus.

Eric

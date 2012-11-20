Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2KTTKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:10:45 -0500
Received: from nm3-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.108]:29192
	"EHLO nm3-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab2KTTKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:10:43 -0500
X-Yahoo-Newman-Id: 444346.84541.bm@smtp112.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EzT.jb0VM1kyQdHkC3y1AwMQscMOf.lfJ1s0cAvvGd_dkZ1
 bxxIn3kgmd006j_5Qeag1VfBPGZuZzV67BXAHQe_9PjWTbf7K.Jw6u.MYAQd
 lzcTFioFaYjEOm_Kw49KSgtNNA0Egd6sMsJA.l9osIuHKQu5fUCMb5eCLbKP
 MOYTzaH5BonSJlD7D6WPjqckIkP9vR8nfPAC_8NEXrk_m006Y.dsVRRBam9P
 w.JYCdjylo0pX2J4BGt4KxvX3i5OBYN9cQW6X.JBEbkP8p2I_PCH8xmgw9hz
 r4kO0E1UrNIkdzZUnc8t8A9Fc1rJHkEWEm1344yJ_K9QT4hUW5a1v0jkMVc8
 7BbnG6DPy_Iio2Q2dRTIojWpVfDtt79T5VoIQmDPWATEfAPJ191ikfZksLiE
 VWlWhTBZyWSoZYxfb7fJxchfS_jQ3iShVMEy4hTFVO3WFj9Hr9T44SUkUxV3
 ln_fvPoi4_qh931i9e9yorxLoW1LVFwl0HQDdjocyIkDNFh37zKpDFWoNepR
 c4OsnuBJtw38-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50ABD5B9.6020701@att.net>
Date: Tue, 20 Nov 2012 13:10:49 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] bug.h: Prevent double evaulation of in BUILD_BUG_ON
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com> <1352844821-18952-6-git-send-email-daniel.santos@pobox.com> <20121115150726.GD4956@x1.osrc.amd.com> <50A53E53.8080404@att.net> <20121117143840.GB16441@x1.osrc.amd.com>
In-Reply-To: <20121117143840.GB16441@x1.osrc.amd.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2012 08:38 AM, Borislav Petkov wrote:
> On Thu, Nov 15, 2012 at 01:11:15PM -0600, Daniel Santos wrote:
>> Ah yes. I did notice that at one point, but I think it slipped
>> my mind. Also, the kernel has introduced me to the usage of the
>> !! construct, of which I'm well versed in its affects in various
>> situations and how gcc's optimizer ends up treating its usage, so
>> probably another reason I didn't change it immediately. But it's
>> basically shorthand for the expression (condition ? 1 : 0), correct?

Oh, this is embarrassing, The sentence above should have read:

... the kernel has introduced me to the usage of the !! construct, of which I'm *not* well versed in ...

hah! oh well


> I don't think so: "!!" is simply a double negation which turns the
> whatever wild construct you have into either 0 or 1, depending on what
> it evaluates to.
>
> But I don't know what the standard says so you'll have to check :-)

Here we go, from section §6.5.3.3:

The result of the logical negation operator ! is 0 if the value of its
operand compares unequal to 0, 1 if the value of its operand compares
equal to 0. The result has type int. The expression !E is equivalent to
(0==E).

I simply wasn't aware that it promised a "true" value to be one
exactly.  Hurray for expanding horizons! :)

Daniel

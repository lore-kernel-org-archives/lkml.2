Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2CMUOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:14:20 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35821 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2CMUOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:14:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120313195750.GB24124@thunk.org>
References: <CACbLGLK8ZLLHzykKb8LRZO+x+_Cqe6r_dna1=QC4nDGSyWrfNw@mail.gmail.com>
	<CACbLGLJTzW-A=oW2hC1URLSCEeVX4RDg--eO=SS3kznXMdB4MQ@mail.gmail.com>
	<20120313195750.GB24124@thunk.org>
Date: Tue, 13 Mar 2012 21:14:18 +0100
X-Google-Sender-Auth: YPLISFfdZNZsoZPUdHCIcSdAxac
Message-ID: <CACbLGLLLtD8TJd-VvdkQYo48nT5NFE8bmH8aHtwy6-hoCbqL9g@mail.gmail.com>
Subject: Re: Fwd: ext4 extents.c bug
From: Frej Eriksson <frej.eriksson@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Frej Eriksson <frej.eriksson@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your the information! If i get you correct does it mean
that you need to have an updated version of both the kernel and
e2fsprogs in order to have the issue fixed? Or is it enough to run
e2fsprogs with the patch applied?

Best regards,
Frej Eriksson

On Tue, Mar 13, 2012 at 8:57 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Mar 13, 2012 at 08:39:56PM +0100, Frej Eriksson wrote:
>> [  950.128885] ------------[ cut here ]------------
>> [  950.128893] kernel BUG at /build/buildd/linux-2.6.35/fs/ext4/extents.c:1971!
>
> Your file system is corrupted, and there are two bugs.  (1) e2fsck
> wasn't detecting this form of file system corruption (a zero-length
> extent entry), and (2) the kernel was not noticing until an assertion
> check using BUG_ON, instead of flagging this as a file systme error.
>
> The fixes for both of these problems, in the kernel and in e2fsprogs,
> are here:
>
>    http://article.gmane.org/gmane.comp.file-systems.ext4/31359
>    http://article.gmane.org/gmane.comp.file-systems.ext4/31360
>
> Best regards,
>
>                                                - Ted

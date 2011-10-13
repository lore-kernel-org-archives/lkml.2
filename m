Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1JMFBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 01:01:38 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:45510 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1JMFBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 01:01:37 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC : fat : default errors use FAT_ERRORS_CONT instead of FAT_ERRORS_RO.
References: <CAKYAXd9v_wFg2RQ_R+fYyCJnCbnuMs_VECujOen1GUSGXo3rHw@mail.gmail.com>
Date: Thu, 13 Oct 2011 14:01:32 +0900
In-Reply-To: <CAKYAXd9v_wFg2RQ_R+fYyCJnCbnuMs_VECujOen1GUSGXo3rHw@mail.gmail.com>
	(NamJae Jeon's message of "Thu, 13 Oct 2011 09:24:52 +0900")
Message-ID: <87vcrtqyc3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NamJae Jeon <linkinjeon@gmail.com> writes:

> Hi ogawa.
>
> I found different error exception between linux fat and windows fat.
>
> When fat is currputed by sudden unplug usb device formatted fat, fat
> does never change RO partition on windows.
>
> It said windows fat provide a chance that continuously access
> partition except corrupted file.
>
> Currently when access corrupted file, linux fat change RO parition
> from RW. So user no longer do open/write on linux fat.
>
> I suggest that the default errors of linux fat use FAT_ERRORS_CONT
> instead of FAT_ERRORS_RO.
>
> I want to know your opinion.

I think it is dangerous, and the default should be safer side.

If driver noticed the corruption, it means FS is not unknown state
anymore.  Any files/directories are possibly corrupted.

Even if you change the file that seems to be uncorrupted, it may make FS
unrecoverable more. (e.g. lose all data in worst case)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

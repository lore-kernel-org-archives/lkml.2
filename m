Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1DZMiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:38:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1DZMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:38:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Amit Ben Shahar <amit.bens@gmail.com>
Subject: Re: Why is the 'loff_t *offset' parameter in the file_operations' read function a pointer?
Date: Tue, 26 Apr 2011 14:37:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <BANLkTimaJFFCCQOA6=G4i95PsJK_S2bf9Q@mail.gmail.com>
In-Reply-To: <BANLkTimaJFFCCQOA6=G4i95PsJK_S2bf9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261437.53925.arnd@arndb.de>
X-Provags-ID: V02:K0:qns72vFMSnGt4PqgLE/uzIOwB1VtLDy9lyzbYfSxLSd
 T1csqScmkmbCOzuFk/hAKG0aZ8wxkrOCPLYHMB0UTG7HME6iIn
 55fsfBAo+0uvitU/Pct9CYISlBYGDVmtePD0isRjc8+LoKSZEr
 2Jxak9bosqCvq0PLvQoWom/nsDSDbnAw0tLw0foBz8Cu+wjVs7
 B05vx/8W0nyNu4l3dr6HQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 April 2011, Amit Ben Shahar wrote:
> (if i'm off topic or should look elsewhere i apologize - couldn't find
> information anywhere)
> I am coding a kernel module and implementing a file's operations, the
> read operation received an loff_t *offset parameter, why is this a
> pointer? is it in userspace?

The read function must update the offset independent of the return value.
See simple_read_from_buffer() as an example.

	Arnd

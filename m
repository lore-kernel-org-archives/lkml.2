Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0GHGjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:39:53 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:44122 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0GHGjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:39:52 -0400
Date: Thu, 8 Jul 2010 08:40:10 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]video:gspca.c Fix  warning: case value '7' not in
 enumerated type 'enum v4l2_memory'
Message-ID: <20100708084010.6a15f8c3@tele>
In-Reply-To: <1278564378-19855-1-git-send-email-justinmattock@gmail.com>
References: <1278564378-19855-1-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Jul 2010 21:46:18 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> This fixes a warning I'm seeing when building:
>   CC [M]  drivers/media/video/gspca/gspca.o
> drivers/media/video/gspca/gspca.c: In function 'vidioc_reqbufs':
> drivers/media/video/gspca/gspca.c:1508:2: warning: case value '7' not
> in enumerated type 'enum v4l2_memory'

Hi Justin,

I don't agree with your patch: the value GSPCA_MEMORY_READ must not be
seen by user applications.

The warning may be simply fixed by (change the line numbers):

--- gspca.c~	2010-07-08 08:15:14.000000000 +0200
+++ gspca.c	2010-07-08 08:28:52.000000000 +0200
@@ -1467,7 +1467,8 @@ static int vidioc_reqbufs(struct file *f
 	struct gspca_dev *gspca_dev = priv;
 	int i, ret = 0, streaming;
 
-	switch (rb->memory) {
+	i = rb->memory;			/* (avoid compilation warning) */
+	switch (i) {
 	case GSPCA_MEMORY_READ:			/* (internal call) */
 	case V4L2_MEMORY_MMAP:
 	case V4L2_MEMORY_USERPTR:

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

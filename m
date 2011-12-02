Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1LBMd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:33:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab1LBMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:33:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
Date: Fri, 02 Dec 2011 13:33:36 +0100
Message-ID: <42689146.OPtqLboC2m@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <1322817178-8931-6-git-send-email-ming.lei@canonical.com>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com> <1322817178-8931-6-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Bs15LHzdMzNYFGXvDhGyaQjCtSWU65DJz1hQlXNfwXZ
 XtRiMYK8ygLJbklUye5++Csefw6/XQmVPK9/8htDX/bbHXYeeh
 cIPud0f+nU8JSFfGA/RZp2F1Sm/fhOBBDaq6xJjr9NdBS5nNm9
 vDqr8NqfMrZfnrnOxfv5BKtBrEGW30U7PsviV3Vx1LrSlhaDED
 U6wUoLjDYtTEfKmmH+6iVBlWTQVnHq4/M4ECBOpd+fGO+2Porh
 ll0LTMaRYSx9NXQ3R4QJEnyH9ymzHRFHg7afDz1sdwdmV9G0Bv
 1e5+/I/nkdGR9rDmOGaQqs5W1QzIoA44xEAW1BWafxhXvhQdM9
 zXa7OfLXDEV8wUQ/Qsmk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 December 2011 17:12:56 Ming Lei wrote:
> +/**
> + * struct v4l2_fd_result - VIDIOC_G_FD_RESULT argument
> + * @buf_index: entry, index of v4l2_buffer for face detection
> + * @face_cnt:  return, how many faces detected from the @buf_index
> + * @fd:                return, result of faces' detection
> + */
> +struct v4l2_fd_result {
> +       __u32   buf_index;
> +       __u32   face_cnt;
> +       __u32   reserved[6];
> +       struct v4l2_fd_detection *fd;
> +};


This data structure is not 32/64 bit safe: running a 64 bit kernel with 32 bit
user space will see an incompatible layout.

One way to solve this is to remove the pointer and just start the array
directly after the __u32 members. Alternatively, you can use a __u64
to pass the pointer in an integer representation.

A nicer interface from the data structure perspective would be to
get rid of the array altogether and always return exactly one face.

	Arnd

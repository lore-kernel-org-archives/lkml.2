Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab1KRVEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:04:11 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60767 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab1KRVEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <20111118202552.GB2203@ZenIV.linux.org.uk>
References: <1321646674-26890-1-git-send-email-levinsasha928@gmail.com>
	<20111118202552.GB2203@ZenIV.linux.org.uk>
Date: Fri, 18 Nov 2011 23:04:08 +0200
X-Google-Sender-Auth: jRr9556C_1CRbj5ImASLE8Rnyo8
Message-ID: <CAOJsxLG7Q-DEAOXo0SpsBDFRZzFRkRdA4xnP48Khu4QdCrdrWA@mail.gmail.com>
Subject: Re: [PATCH] pipe: Fail cleanly when root tries F_SETPIPE_SZ with big size
From: Pekka Enberg <penberg@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 10:04:34PM +0200, Sasha Levin wrote:
>> +     if (nr_pages * sizeof(struct pipe_buffer) > KMALLOC_MAX_SIZE)
>> +             return -ENOMEM;

On Fri, Nov 18, 2011 at 10:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> nr_pages is unsigned long, sizeof is greater than 1, KMALLOC_MAX_SIZE is
> unsigned long...  So write that check as KMALLOC_MAX_SIZE / sizeof > nr_pages

We could just use __GFP_NOWARN here and let kcalloc() deal with the
overflow case.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1IVXYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:24:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48854 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab1IVXYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:24:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=aMHet6OKsw44gfDeSC8mngOfiii79CyLEAzRPLIwmBAnppHC/HOW3uzf9A/lyfu8G
	CNU4YrM0h62rvt9Gg3OzQ==
MIME-Version: 1.0
In-Reply-To: <20110922235417.6cf88f7d@lxorguk.ukuu.org.uk>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
	<1316725029-22737-2-git-send-email-ccross@android.com>
	<20110922235417.6cf88f7d@lxorguk.ukuu.org.uk>
Date: Thu, 22 Sep 2011 16:24:21 -0700
X-Google-Sender-Auth: JfGWPzYPHxpkfiqDaTkX7yEJxGI
Message-ID: <CAMbhsRQXS_bcvOmN7Bnofr9Ana_6b23rakriQU51RjTcS3=63Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs: seq_file: add seq_reserve
From: Colin Cross <ccross@android.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 3:54 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 22 Sep 2011 13:57:07 -0700
> Colin Cross <ccross@android.com> wrote:
>
>> Adds a seq_reserve function to allow users of the seq_file interface to
>> increase the initial size of the buffer.  Avoids repeated allocations and
>> calls to the show function in cases where large buffers of known size are
>> needed.
>
> Would it not be better to have something akin to
>
>
>        void seq_set_buffer(struct seq_file *m, void *ptr, size_t size)
>        {
>                m->buf = ptr;
>                m->size = size;
>                m->private = 1;
>        }
>
> and let the caller simply provide a buffer by any means it wishes (even
> statically) and free it again itself. That keeps the caller fully in
> control when it wishes to be.

What would happen when seq_read overflowed the buffer?  It wouldn't be
able to reallocate it.

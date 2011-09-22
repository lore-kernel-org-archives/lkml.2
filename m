Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1IVWzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:55:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60569 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751560Ab1IVWz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:55:29 -0400
Date: Thu, 22 Sep 2011 23:54:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/3] fs: seq_file: add seq_reserve
Message-ID: <20110922235417.6cf88f7d@lxorguk.ukuu.org.uk>
In-Reply-To: <1316725029-22737-2-git-send-email-ccross@android.com>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
	<1316725029-22737-2-git-send-email-ccross@android.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011 13:57:07 -0700
Colin Cross <ccross@android.com> wrote:

> Adds a seq_reserve function to allow users of the seq_file interface to
> increase the initial size of the buffer.  Avoids repeated allocations and
> calls to the show function in cases where large buffers of known size are
> needed.

Would it not be better to have something akin to


	void seq_set_buffer(struct seq_file *m, void *ptr, size_t size)
	{
		m->buf = ptr;
		m->size = size;
		m->private = 1;
	}

and let the caller simply provide a buffer by any means it wishes (even
statically) and free it again itself. That keeps the caller fully in
control when it wishes to be.

Alan

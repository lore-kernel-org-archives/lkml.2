Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430Ab2EJStw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:49:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44134 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761346Ab2EJStt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:49:49 -0400
Message-ID: <1336675787.22495.29.camel@joe2Laptop>
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Date: Thu, 10 May 2012 11:49:47 -0700
In-Reply-To: <1188908028.170.1336674698865.JavaMail.mail@webmail09>
References: <cover.1336619038.git.koverstreet@google.com>
	 <1188908028.170.1336674698865.JavaMail.mail@webmail09>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 23:10 -0400, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
[]
> +
> +void btree_read_done(struct closure *cl)
> +{
[]
> +	if (b->written < btree_blocks(b))
> +		bset_init_next(b);
> +
> +	if (0) {
> +err:		set_btree_node_io_error(b);
> +		cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
> +				err, PTR_BUCKET_NR(b->c, &b->key, 0),
> +				index(i, b), i->keys);
> +	}

Hi Kent

trivia:  This if (0) is an exceedingly ugly style.

I'd much prefer:

	if (foo)
		bar();

	goto exit;

err:
	set_btree_node_io_error(b);
	cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
			err, PTR_BUCKET_NR(b->c, &b->key, 0),
			index(i, b), i->keys);

exit:
	etc...



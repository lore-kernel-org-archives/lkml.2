Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2IZNtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:49:32 -0400
Received: from mx0.aculab.com ([213.249.233.131]:49813 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755642Ab2IZNtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:49:31 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v6] hashtable: introduce a small and naive hashtable
Date: Wed, 26 Sep 2012 14:45:53 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com>
In-Reply-To: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v6] hashtable: introduce a small and naive hashtable
thread-index: Ac2b5UevRi4V+Dt9TKmNFVq5CZpGywAB3hQA
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Sasha Levin" <levinsasha928@gmail.com>, <torvalds@linux-foundation.org>
Cc: <tj@kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>,
        <ebiederm@xmission.com>, <mathieu.desnoyers@efficios.com>,
        <neilb@suse.de>, <bfields@fieldses.org>, <ejt@redhat.com>,
        <snitzer@redhat.com>, <edumazet@google.com>, <josh@joshtriplett.org>,
        <rmallon@gmail.com>, <palves@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amazing how something simple gets lots of comments and versions :-)

> ...
> + * This has to be a macro since HASH_BITS() will not work on pointers since
> + * it calculates the size during preprocessing.
> + */
> +#define hash_empty(hashtable)							\
> +({										\
> +	int __i;								\
> +	bool __ret = true;							\
> +										\
> +	for (__i = 0; __i < HASH_SIZE(hashtable); __i++)			\
> +		if (!hlist_empty(&hashtable[__i]))				\
> +			__ret = false;						\
> +										\
> +	__ret;									\
> +})

Actually you could have a #define that calls a function
passing in the address and size.
Also, should the loop have a 'break' in it?

	David




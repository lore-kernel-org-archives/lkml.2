Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2LUVgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 16:36:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2LUVgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 16:36:12 -0500
Date: Fri, 21 Dec 2012 13:36:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v2] mm,ksm: use new hashtable implementation
Message-Id: <20121221133610.bb516813.akpm@linux-foundation.org>
In-Reply-To: <1356112012-24584-1-git-send-email-sasha.levin@oracle.com>
References: <1356112012-24584-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012 12:46:50 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> Switch ksm to use the new hashtable implementation. This reduces the amount of
> generic unrelated code in the ksm module.

hm, include/linux/hashtable.h:hash_min() is rather dangerous - it
returns different values depending on the size of the first argument. 
So if the calling code mixes up its ints and longs (and boy we do that
a lot), the result will work on 32-bit and fail on 64-bit.

Also, is there ever likely to be a situation where the first arg to
hash_min() is *not* a pointer?  Perhaps it would be better to concede
to reality: rename `key' to `ptr' and remove all those typcasts you
just added.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab2EVP30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:29:26 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58293 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758826Ab2EVP3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:29:24 -0400
Message-ID: <4FBBB059.1060903@parallels.com>
Date: Tue, 22 May 2012 19:27:21 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2] slab+slob: dup name string
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home>
In-Reply-To: <alpine.DEB.2.00.1205220857380.17600@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 05:58 PM, Christoph Lameter wrote:
> On Tue, 22 May 2012, Glauber Costa wrote:
>
>> [ v2: Also dup string for early caches, requested by David Rientjes ]
>
> kstrdups that early could cause additional issues. Its better to leave
> things as they were.
>

For me is really all the same. But note that before those kstrdups, we 
do a bunch of kmallocs as well already. (ex:

/* 4) Replace the bootstrap head arrays */
{
	struct array_cache *ptr;

	ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);

Which other point of issues do you see besides the memory allocation 
done by strdup?

I agree with your comment that we shouldn't worry about those caches, 
because only init code uses it.

Weather or not David's concern of wanting to delete those caches some 
day is valid, I'll leave up to you guys to decide


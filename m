Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0DURGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:06:25 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42226 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0DURGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r20Ruvag1QtgaxOe2w79iSCRgfKeba+vbn27AznspF8zjA+t+WzoZ8UhN6sFvKxUAT
         2N0ZedZFlvRgpn3o/a83WfqV7aCJfMKW+uOkNP0YKbfa9k0jnpJEXuG1U4WGLogdXxUF
         OWwYrLoGIpw8UF6SNPosbtqX9E5LX+Je58Nn4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1004210914570.4959@router.home>
References: <4BC6CB30.7030308@kernel.org>
	 <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
	 <4BC6FBC8.9090204@kernel.org>
	 <w2h28c262361004150449qdea5cde9y687c1fce30e665d@mail.gmail.com>
	 <alpine.DEB.2.00.1004161105120.7710@router.home>
	 <1271606079.2100.159.camel@barrios-desktop>
	 <alpine.DEB.2.00.1004191235160.9855@router.home>
	 <4BCCD8BD.1020307@kernel.org> <20100420150522.GG19264@csn.ul.ie>
	 <alpine.DEB.2.00.1004210914570.4959@router.home>
Date: Thu, 22 Apr 2010 02:06:22 +0900
Message-ID: <i2t28c262361004211006yc1301a84ncf9b3acbff37e212@mail.gmail.com>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:15 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Tue, 20 Apr 2010, Mel Gorman wrote:
>
>> alloc_pages_exact_node() avoids a branch in a hot path that is checking for
>> something the caller already knows. That's the reason it exists.
>
> We can avoid alloc_pages_exact_node() by making all callers of
> alloc_pages_node() never use -1. -1 is ambiguous and only rarely will a
> caller pass that to alloc_pages_node().

That's very reasonable to me.
Then, we can remove alloc_pages_exact_node and nid < 0 check in
alloc_pages_node at the same time.

Mel. Could you agree?

Firstly Tejun suggested this but I didn't got the point.
Sorry for bothering you.

Okay. I will dive into this approach.
Thanks for careful review, All.


> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim

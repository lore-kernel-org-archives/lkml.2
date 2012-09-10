Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2IJJMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:12:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64677 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2IJJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:12:30 -0400
Subject: Re: [PATCH] lib: gcd: prevent possible div by 0
From: Eric Dumazet <eric.dumazet@gmail.com>
To: dave@gnu.org
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
In-Reply-To: <1347203038.3288.1.camel@offbook>
References: <1347203038.3288.1.camel@offbook>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Sep 2012 11:12:23 +0200
Message-ID: <1347268343.1234.1307.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-09 at 17:03 +0200, Davidlohr Bueso wrote:
> Account for properties when a and/or b are 0:
> gcd(0, 0) = 0
> gcd(a, 0) = a
> gcd(0, b) = b
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  lib/gcd.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/gcd.c b/lib/gcd.c
> index cce4f3c..7e163c6 100644
> --- a/lib/gcd.c
> +++ b/lib/gcd.c
> @@ -7,6 +7,9 @@ unsigned long gcd(unsigned long a, unsigned long b)
>  {
>  	unsigned long r;
>  
> +	if (!a || !b)
> +		return a | b;

This seems overkill

> +
>  	if (a < b)
>  		swap(a, b);

better here to :
	if (!b)
		return a;

>  	while ((r = a % b) != 0) {



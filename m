Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0LBKUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:20:44 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:51041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0LBKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:20:41 -0500
Subject: Re: [PATCH 2/3] lib: Improve EWMA efficiency by using bitshifts
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, randy.dunlap@oracle.com, br1@thinktube.com,
        peterz@infradead.org, blp@cs.stanford.edu,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars_Ericsson@telia.com, j@w1.fi, stefanr@s5r6.in-berlin.de,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com
In-Reply-To: <20101202101236.22988.1691.stgit@localhost6.localdomain6>
References: <20101202101231.22988.33396.stgit@localhost6.localdomain6>
	 <20101202101236.22988.1691.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 11:20:22 +0100
Message-ID: <1291285222.3481.45.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 19:12 +0900, Bruno Randolf wrote:

> +	/* get bitshift for weight */
> +	for (n = 0; !(weight & 1); n++)
> +		weight = weight >> 1;
> +	WARN_ON(weight > 1 || n < 1);

I'm sure there's something like log2() (and is_power_of_2() for the
warning) in the kernel already -- no need to reimplement it...

johannes


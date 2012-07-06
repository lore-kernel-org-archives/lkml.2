Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2GFJLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:11:06 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60110 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab2GFJKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:10:49 -0400
Message-ID: <4FF6AA11.2010303@parallels.com>
Date: Fri, 6 Jul 2012 13:04:17 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH SLAB 1/2 v3] duplicate the cache name in SLUB's saved_alias
 list, SLAB, and SLOB
References: <1341561286.24895.9.camel@ThinkPad-T420>
In-Reply-To: <1341561286.24895.9.camel@ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 11:54 AM, Li Zhong wrote:
> +	if (!c && lname)
> +		kfree(lname);
> +
kfree can still be validly called with a NULL argument. No need for the
lname in the conditional.


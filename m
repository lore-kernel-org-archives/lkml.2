Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0FEOxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:53:32 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61409 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab0FEOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aXyPPyMeopb7K+XuQe99MxhiYZ528D7MxfXfKOYGgp8hG2QUVGqsDeAFXy+9ATAgq2
         DsVkXB/yPgHbfAEoYecLSulnGjyItwK7KMHGRvkQ5now2XrktyDzh0cR1fkQl6kqgdzy
         MneKfH5GsR/9jMyJn4WowrYLsy5hvNPZThAxY=
Subject: Re: [RFC PATCH v7 08/19] Make __alloc_skb() to get external buffer.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <1275732899-5423-8-git-send-email-xiaohui.xin@intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-2-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-3-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-4-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-5-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-6-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-7-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-8-git-send-email-xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 16:53:24 +0200
Message-ID: <1275749604.5238.239.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 05 juin 2010 à 18:14 +0800, xiaohui.xin@intel.com a écrit :
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 	child->fclone = SKB_FCLONE_UNAVAILABLE;
>  	}
> +	/* Record the external buffer info in this field. It's not so good,
> +	 * but we cannot find another place easily.
> +	 */
> +	shinfo->destructor_arg = ext_page;
> +


Yes this is a big problem, its basically using a cache line that was not
touched before.



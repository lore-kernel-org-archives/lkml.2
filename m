Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0JKPmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:42:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63696 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0JKPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aQvZaChy88diL9yFXn37YghxmpiMBu0yxZKmTGSsYFr6EbsAcKREYZR54e+ZYfx4t+
         HM2dmpV71itzRLMyCVjdDyzmwsTNcm+NB49X1Vs27X0F/HC9WEyJEYuLWr94UNcb8lBI
         ByxsSbRoUlw98pOKZCQ4Ffh5q8yET0aa65MC8=
Subject: Re: [PATCH v12 06/17] Use callback to deal with skb_release_data()
 specially.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, mingo@elte.hu,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <20101011.082728.193709462.davem@davemloft.net>
References: <f2bf65a8a7676bbd3e8a749ae93d99e88671d35d.1285853725.git.xiaohui.xin@intel.com>
	 <20101001.001439.85411154.davem@davemloft.net>
	 <F2E9EB7348B8264F86B6AB8151CE2D793064B2A9D8@shsmsx502.ccr.corp.intel.com>
	 <20101011.082728.193709462.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 17:42:11 +0200
Message-ID: <1286811731.2737.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 11 octobre 2010 à 08:27 -0700, David Miller a écrit :
> From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
> Date: Mon, 11 Oct 2010 15:06:05 +0800
> 
> > That's to avoid the new cache miss caused by using destructor_arg in data path
> > like skb_release_data().
> > That's based on the comment from Eric Dumazet on v7 patches.
> 
> Thanks for the explanation.

Anyway, frags[] must be the last field of "struct skb_shared_info"
since commit fed66381 (net: pskb_expand_head() optimization)

It seems Xin worked on a quite old tree.




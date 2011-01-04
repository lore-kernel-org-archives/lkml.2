Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1ADQFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:05:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34439 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1ADQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:05:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C6Xq1OAKHZ20sN/ommQxYYirNsNy9v70y/8sYE4ICrp6EhumqzGEfaYdWn59EO2D93
         yEaPbXHUCdyXy7Q4+7rak56fGUVYbNUQdzZCi0u9NpGhTSwL0njgVwYyPzN/Kc14F14r
         D+iFppkyPRQEHO09ocduTWVANDCctJsNS+Sxo=
Subject: Re: [PATCH 1/2] kref: add kref_test_and_get
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>
In-Reply-To: <4D23423A.60707@redhat.com>
References: <4CFF3DA4.5060705@jp.fujitsu.com>
	 <4CFF9A2C.1070401@fusionio.com> <4D025154.8030400@redhat.com>
	 <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com>
	 <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com>
	 <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com>
	 <4D13810B.8000304@redhat.com> <20101224192916.GB2082@redhat.com>
	 <4D23423A.60707@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 17:05:14 +0100
Message-ID: <1294157114.3579.102.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 janvier 2011 à 16:52 +0100, Jerome Marchand a écrit :
> Add kref_test_and_get() function, which atomically add a reference only if
> refcount is not zero. This prevent to add a reference to an object that is
> already being removed.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

> +int kref_test_and_get(struct kref *kref)
> +{
> +	int ret;
> +	smp_mb__before_atomic_inc();
> +	ret = atomic_inc_not_zero(&kref->refcount);
> +	smp_mb__after_atomic_inc();
> +	return ret;
> +}
> +
> +/**

atomic_inc_not_zero() has full memory barrier semantic already, you dont
need smp_mb__before_atomic_inc() or smp_mb__after_atomic_inc();




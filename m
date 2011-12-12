Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1LLI5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:57:20 -0500
Received: from [205.233.59.134] ([205.233.59.134]:54869 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1LLI5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:57:19 -0500
Message-ID: <1323680190.16764.48.camel@twins>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Peter Zijlstra <peterz@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
Date: Mon, 12 Dec 2011 09:56:30 +0100
In-Reply-To: <CACVXFVMDEeDBkAdv=AkRZuOH1sNdMGjR3PeHYMVLhwR+FB8gOg@mail.gmail.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.295857663@chello.nl>
	 <CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
	 <1323529084.16764.5.camel@twins>
	 <CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
	 <1323546551.2822.14.camel@laptop>
	 <CACVXFVNAAXAWtTncahb=sADHxmZOmdDOJA1FUX8Qt4ZR3To_qg@mail.gmail.com>
	 <1323607627.16764.13.camel@twins>
	 <CACVXFVOYj+Mmph8WGQUdcGS8t-GPr9y3crPuz0SrBCtOmCvstQ@mail.gmail.com>
	 <1323617738.16764.21.camel@twins> <1323636148.16764.44.camel@twins>
	 <CACVXFVMDEeDBkAdv=AkRZuOH1sNdMGjR3PeHYMVLhwR+FB8gOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 11:48 +0800, Ming Lei wrote:
> >  LOCK
> >  obj = lookup(); /* lets assume obj != NULL */
> >  kref_get(&obj->ref);
> >  UNLOCK
> >
> >  value = obj->member;
> >
> >  kref_put(&obj->ref);
> >
> > Now, under our memory model, the read from obj->member can both happen,
> > or be observed to happen before the increment from kref_get() is
> > processed.
> 
> It should be the problem if another CPU observed that write/read obj
> is done before kref_get. 

WHY?!?!?!

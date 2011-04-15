Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1DOJU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 05:20:27 -0400
Received: from skl2.ukl.uni-freiburg.de ([193.196.199.2]:54264 "EHLO
	relay2.uniklinik-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847Ab1DOJUZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 05:20:25 -0400
X-Greylist: delayed 1587 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Apr 2011 05:20:25 EDT
Subject: Re: [Regression] 2.6.38 ncpfs
From: "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
To: Bongani Hlope <bonganih@bankservafrica.com>
Cc: torvalds@linux-foundation.org, arnd@arndb.de, npiggin@kernel.dk,
        greg@kroah.com, hch@lst.de, bonganilinux@mweb.co.za, rjw@sisk.pl,
        petr@vandrovec.name, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4DA815B6020000AC0004595E@CLU_MAIL.BANKSERV.CO.ZA>
References: <4DA815B6020000AC0004595E@CLU_MAIL.BANKSERV.CO.ZA>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Apr 2011 10:53:50 +0200
Message-ID: <1302857630.2798.0.camel@pst15.ukl.uni-freiburg.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-NAI-Spam-Flag: NO
X-NAI-Spam-Level: *
X-NAI-Spam-Threshold: 5
X-NAI-Spam-Score: 1.2
X-NAI-Spam-Report: 3 Rules triggered
	*  1 -- FROM_ALIAS_QUOTES_EVOL_2
	*  0.2 -- RCVD_FROM_BY_ENVFRM_1_AT_2
	*  0 -- RV3827
X-NAI-Spam-Version: 2.2.0.9286 : core <3827> : streams <621546> : uri
 <851501>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bongani, Linus et al.

> > You might also try to replace it with
> > 
> >     BUG_ON(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex))
> > 
> > ie add that "d_parent" there. Just for testing - I think the real fix
> > really is to remove it, but I'd personally be happier knowing that
> > _if_ it were to have that d_parent there, it would have worked.
> 
> I've made that change and ncpfs works fine with it. I've attached a
> patch that changes the BUG_ON to look at the parent.

Seconded, checked it with the Novell servers in our clinic and it works
like a charm - even with the large directories for which I still have to
revert commit 3825bdb7ed920845961f32f364454bee5f469abb from 2.6.37.6
(https://lkml.org/lkml/2011/1/26/302). Thanks a lot!

Bernd



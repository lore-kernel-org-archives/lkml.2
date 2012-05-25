Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab2EYWss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:48:48 -0400
Received: from nm17.access.bullet.mail.sp2.yahoo.com ([98.139.44.144]:26728
	"HELO nm17.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755099Ab2EYWsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:48:47 -0400
X-Yahoo-Newman-Id: 855148.51834.bm@omp1003.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: u9pBy9gVM1nFk8_7cEUx0k7RgxKZbmrH9iJRHz_EU_Wbamh
 KTOBO8YQivn5.gwPNNKPcVHaXaOAMuHzmVdUYaTVR34kKxBXovUqIY2Nplu9
 ufJwM_D_2ZjRHUndGeuiiBd7kx8U7xwXp7LbvabyE9RiihhMX0GYmTGjPW0X
 j7KTToq45sXrCIc.8nNUVc1ZTbRVsfvs4JzqCScQiVXEi12Ct6Nq0wyMtCti
 6AWirpuH3NfN2aLZtdtSGougKKql4lsylRhoI0MAmTA0nFu4PM8otLYuSDrY
 _pMt6eksCmgLpFrACZHNX6Cygb43g3m8wZCR3goQJimwxEciP_kdiwSeaaPv
 nsweaWY0.yGfLkpNFTDIKy_PwiBUY70PzqBOHRwCGWfbe1AfMki7Wu7.b5jQ
 ifyptuQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FC00C50.3000907@att.net>
Date: Fri, 25 May 2012 17:48:48 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Generic Red-Black Trees (status update)
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For anybody that's keeping up with this, I've gone through multiple
iterations and tests with 9 different gcc versions and concluded that
the search, insert & remove cores need to be coded in rbtree.h, using
the traditional interface (i.e., passing struct rb_node & rb_root
pointers instead of pointers to your specific object types).  The reason
is that gcc can't handle the cool fully-generic code until 4.6.  In gcc
4.5.x, optimization completely breaks expanding the inline functions
into huge bloated  monsters.  Also, while I'm re-coding it all, I'm
adding find_near & insert_near, for more efficient insertion & retrieval
when you already have a node that should be close to the one you want
(which is often the case when inserting many objects at once).

So after I'm done with this, I'll start on a new header file (grbtree.h
probably) using the "grb_" prefix for it's functions that implements the
gcc 4.6.x+ fully generic & type safe interface, but using cute
pre-processor tricks for pre-4.6.x compatibility (basically, something
to consider using once gcc 4.6+ is more widely used).

Daniel

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2AQQEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:04:45 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:33585 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755111Ab2AQQEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:04:43 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YDqDQKwVM1lv9S2JCIzGrEhUBIVefDuENv7du9IRcnrcONV
 BxjqRYXawaQ1xPlM_XcUKbsnpE7oEGJKpSLOR.x.pLsDQTKOfRes75iJPjQz
 E5_O.dlp0QorCw2GFXxKhywjhmZD9.UVL4giKK2wmlHFwLvlPmBSLhTJ5fsM
 FDaTABOWAlTvanYjByJeoCZBW.7JyDA3L6GSyJZ9IDOvhrgsULEVhIOFcU_.
 xkSE3JhReCvTMpkiNB68zblSXYjmUsl0sIm4uCb2mtIs5dTfs1.GBaNR435Y
 q3DGyPQOXwdFihmzMeb10C_FAhKlnhpYwPQherHvfPiGTwpq.FQpDork0kba
 NpIzNE5TqvuL0mlpmk2vhU4q1GDrl.qbRkv4FAszvqPjf42yGB.cIwQOu9MP
 pJPamPnyQ1rNYuDtVM4qSntA.23XgVH2NVPsD
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 17 Jan 2012 10:04:38 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        davem <davem@davemloft.net>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Hung task when calling clone() due to netfilter/slab
In-Reply-To: <1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1201170942240.4800@router.home>
References: <1326558605.19951.7.camel@lappy>    <1326561043.5287.24.camel@edumazet-laptop>   <1326632384.11711.3.camel@lappy>  <1326648305.5287.78.camel@edumazet-laptop>   <alpine.DEB.2.00.1201170910130.4800@router.home>  <1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
  <alpine.DEB.2.00.1201170927020.4800@router.home> <1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012, Eric Dumazet wrote:

> Thanks !
>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

That may not be the end of it. Slub also calls sysfs from sysfs_add_alias
while holding slub_lock.

If sysfs allows user space stuff to run then you cannot really hold any
locks. How is one supposed to sync adding pointers to sysfs structures in
subsystems? Drop all locks and then recheck the memory structures after
the sysfs function returns? Awkward.



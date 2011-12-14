Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1LNOxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:53:46 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:35798 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754806Ab1LNOxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:53:45 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FwzJKyUVM1kfH378u8pJqVAOsGxtn12yH7ka2bnALVfEZfI
 XOax8DEs9yv63OHSYwylxAe5JWG31.oJnKL6u6FcoI2rJ2LSVhlZ527UnlH8
 D5rAXiaMOVqTLy6YVk5WkIHIhiU.8fAp.6P6onQ_260HFYBTRJV7QVDq6o1.
 9PXctopSIBNg79iHTONfkGCxq5KV0nQazNJdPa3q3XK42lSd5lDFw8v2q.gL
 sH_Tff86rkWnr1YuO3gW1zFWEHUzlVHgL_MwK2o5oh_O85r4DEvsTDo.kUi2
 0eRZMs6LQIKtsessiBxStmzhqEdYEJNJbH8cbKmVvHJ_lENKpMl2LFMi_FsV
 h4xeJ7DQMy2ow.kA.j0VCBeeFRsTYAFqsSGUYPAMacW1Taw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 14 Dec 2011 08:53:41 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, "Alex,Shi" <alex.shi@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <alpine.LFD.2.02.1112140846290.1841@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1112140851580.12235@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>  <alpine.DEB.2.00.1112020842280.10975@router.home>  <1323419402.16790.6105.camel@debian>  <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com> 
 <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>  <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>  <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>  <1323842761.16790.8295.camel@debian>
 <1323845054.2846.18.camel@edumazet-laptop> <alpine.LFD.2.02.1112140846290.1841@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Pekka Enberg wrote:

> On Wed, 14 Dec 2011, Eric Dumazet wrote:
> > We should try to batch things a bit, instead of doing a very small unit
> > of work in slow path.
> >
> > We now have a very fast fastpath, but inefficient slow path.
> >
> > SLAB has a litle cache per cpu, we could add one to SLUB for freed
> > objects, not belonging to current slab. This could avoid all these
> > activate/deactivate overhead.
>
> Yeah, this is definitely worth looking at.

We have been down this road repeatedly. Nick tried it, I tried it and
neither got us to something we liked. Please consult the archives.

There was a whole patch series last year that I did introducing per cpu
caches which ended up in the "unified" patches. See the archives for the
various attempts please.


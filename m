Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1HHO6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:58:23 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:40326 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752731Ab1HHO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:58:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _aLaBPwVM1nxWobQMAIaBBU..J62Pk0lsR35FG92FY4K8iT
 t4k5neJSp2wfKh91yLWsMvtOuDjYAgpN_1zhQ5VFoOsvwMZWrFXxJ_pboIOl
 EIREcux1FSyh24SRYZkcgre_UfSUYyPmX0A7qcQ3L1wtWDabKq7cUgmoP4wt
 .RSYlohUJzlkjh1bHyudgDHPaQxiyg7he_z2.koM336zSqplUu56BK1rbY0j
 hzIV1EANOk7fuRUzREyxmLGoIm9Fyh9k69I6Tmr1OUzoPrPh1umt4h2MvGdA
 TusYdRVcSMltHfjCkfsv99c.0luybqJ3x16yDRibDFisGLluSzMZsmHm1BYf
 M8ery7nvHupHQS1bMMEAImJqFRjqmSGxlRcUzE_BaOXRIZw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 8 Aug 2011 09:58:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
In-Reply-To: <alpine.DEB.2.00.1108072155240.9480@tiger>
Message-ID: <alpine.DEB.2.00.1108080957050.8101@router.home>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de> <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com> <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home> <20110805165119.GA11593@redhat.com> <alpine.DEB.2.00.1108051158400.28580@router.home> <20110805171607.GA11703@redhat.com> <alpine.DEB.2.00.1108051312090.28580@router.home> <20110805182008.GA22314@redhat.com>
 <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com> <alpine.DEB.2.00.1108072155240.9480@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Aug 2011, Pekka Enberg wrote:

> Christoph, I've been reading the code and spotted two potential issues in
> __slab_free(). The first one seems like an off-by-one where our comparison in
> deactivate_slab() doesn't match __slab_free.

Would not cause list corruption.

> The other one is remove_full() call in __slab_free() that can get called even
> if cache debugging is not enabled.

The checks for the debug flag are already done in remove_full().

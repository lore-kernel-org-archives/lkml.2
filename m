Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0HWQIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:08:13 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:24837 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754331Ab0HWQIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:08:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1szymjYVM1lyshl1aGoJVTJueP4DU6N9RnW8VFaa1ScJjAR
 o.K54ApJqeRzM96nczbZJ6BVItB2erMXFFWZERuHTZWDQyTHy6qf9it8xxyh
 tKU_8B2fRzIBCk.v0qH9uY7BiH45yJ3YmjPpnXFMPSX9T1Zk49CTcdK9NXd1
 dYhh3XCFWwyq5c1lDi.p3aFS5O8_A5dheeIEmh3G_U9We3284YpelrzhNTO_
 pGvr9fTCGGyZE93jZC6fbebPcuX5I
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 11:08:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gleb Natapov <gleb@redhat.com>
cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 03/12] Add async PF initialization to PV guest.
In-Reply-To: <20100823153549.GU10499@redhat.com>
Message-ID: <alpine.DEB.2.00.1008231105230.8601@router.home>
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-4-git-send-email-gleb@redhat.com> <4C729342.6070205@redhat.com> <20100823153549.GU10499@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Gleb Natapov wrote:

> > The guest will have to align this on a 64 byte boundary, should this
> > be marked __aligned(64) here?
> >
> I do __aligned(64) when I declare variable of that type:
>
> static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);

64 byte boundary: You mean cacheline aligned? We have a special define for
that.

DEFINE_PER_CPU_SHARED_ALIGNED


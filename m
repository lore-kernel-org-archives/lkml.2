Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1CNVXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:23:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50848 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1CNVX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:23:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 22:22:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, G@thunk.org,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Sage Weil <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
References: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <20110314131042.5a7fb32f.akpm@linux-foundation.org> <20110314211119.GC8120@thunk.org>
In-Reply-To: <20110314211119.GC8120@thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103142222.44598.arnd@arndb.de>
X-Provags-ID: V02:K0:pVOn1eTEfdlPYAlIrJ6dAIAYYkhE4R+cmb+G1F2DYWP
 LYy+BBGTma/I565BBK9HVCfP2EKSBtYqHNwODiuwJVJh/uTC9/
 zpG/xmfB0DrUTA0kEy/nh5l/W1rrpIR3W+44+RLfomZDmhxVYl
 VT2A7GFMjPFZ9X751S+mvm+awxLDxp4hbujxbmoOkJA++6hO/r
 VACmuZ2q/TDAG2bM5eGNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 March 2011 22:11:19 Ted Ts'o wrote:
> It wouldn't hurt to have a "flags" field which we could expand later
> --- but that can lead to portability headaches for userspace programs
> that don't know whether a particular kernel is going to support a
> particular flag or not.  So it's certainly not a panacea.

I think adding an unused flags argument can't hurt.

We could be fancy and ignore half the bits but bail out on the other
half with -EINVAL. That would make it possible to add both compatible
(default being full sync on old kernels) and incompatible (getting
rejected on old kernels) flags.

	Arnd

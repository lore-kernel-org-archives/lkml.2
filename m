Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2GZKIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:08:16 -0400
Received: from osrc3.amd.com ([217.9.48.20]:40050 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab2GZKIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:08:12 -0400
Date: Thu, 26 Jul 2012 12:08:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 05/13] driver core: firmware loader: introduce
 firmware_buf
Message-ID: <20120726100806.GC30717@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-6-git-send-email-ming.lei@canonical.com>
 <20120725135948.GD11152@aftab.osrc.amd.com>
 <CACVXFVOBdXubFi7ZRJ2aUHtd8syTzS=yG8GvsCjAOQmihhvwyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVOBdXubFi7ZRJ2aUHtd8syTzS=yG8GvsCjAOQmihhvwyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 10:51:55AM +0800, Ming Lei wrote:
> On Wed, Jul 25, 2012 at 9:59 PM, Borislav Petkov <bp@amd64.org> wrote:
> 
> > This is subtle: the caller of fw_free_buf might forget to assign NULL to
> > the buf ptr.
> 
> Who is the caller? Since it is always called inside firmware loader, we should
> make sure that.
> 
> > Why not pass struct firmware_priv *fw_priv to the function instead and ...
> 
> No, it shouldn't. The lifetime of fw_priv is just same with request_firmware or
> its work_func pair, but firmware_buf may live much longer than fw_priv. You
> will see that fw_free_buf is the release function of kref in firmware_buf.

Actually, this is all moot since you're changing all this in later
patches. I'm staring at the code after patch 10/13 and the check is
gone.

So nevermind.

[ … ]

> Suppose you are right, it shouldn't be done in this patch since this
> patch just converts to firmware_buf.

Wherever you find its suitable.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

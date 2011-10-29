Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1J2Ggc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 02:36:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50984 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1J2Ggb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 02:36:31 -0400
Date: Sat, 29 Oct 2011 09:32:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, dmitry.torokhov@gmail.com,
        jkosina@suse.cz, gregkh@suse.de, ohering@suse.com,
        linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
        joe@perches.com, devel@linuxdriverproject.org
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Message-ID: <20111029063240.GH14881@longonot.mountain>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1110290041500.31615@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1110290041500.31615@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EAB9EBF.007F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 12:54:34AM +0200, Jesper Juhl wrote:
> > +			default:
> > +				pr_err("unhandled packet type %d, tid %llx len %d\n",
> > +				   desc->type,
> > +				   req_id,
> > +				   bytes_recvd);
> 
> Why not:
> 
>                                 pr_err("unhandled packet type %d, tid %llx 
>                                        len %d\n", desc->type, req_id, bytes_recvd);

Because then the printk would be messed up?  Your final printed
string would look like:

"unhandled packet type %d, tid %llx 
                                       len %d\n"

Don't break strings up across lines because it breaks grep.  If K. Y.
wants to put all the parameters on one line instead of three that
would probably be better, but in the end who cares?

regards,
dan carpenter

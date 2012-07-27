Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2G0O4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:56:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44754 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab2G0O4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:56:41 -0400
Date: Fri, 27 Jul 2012 09:51:29 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        m.selhorst@sirrix.com, safford@us.ibm.com
Subject: Re: [PATCH 1/2] tpm: Move tpm_get_random api into the TPM device
 driver
Message-ID: <20120727145129.GB22046@linux.vnet.ibm.com>
References: <1339094567.21398.2.camel@key-ThinkPad-W510>
 <1339094834.21398.4.camel@key-ThinkPad-W510>
 <5011DC84.6010003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5011DC84.6010003@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072714-3534-0000-0000-00000AD592CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 05:10:44PM -0700, H. Peter Anvin wrote:
> On 06/07/2012 11:47 AM, Kent Yoder wrote:
> >Move the tpm_get_random api from the trusted keys code into the TPM
> >device driver itself so that other callers can make use of it. Also,
> >change the api slightly so that the number of bytes read is returned in
> >the call, since the TPM command can potentially return fewer bytes than
> >requested.
> >
> >Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> 
> I see a second problem with this patch: you don't seem to handle the
> case where you get a short return anywhere in your code.  Presumably
> this should either be considered an error condition, or you need to
> create a private wrapper which can loop and make additional
> requests.
> 
> As it is if you get a short return you simply proceed as if you had
> gotten what you requested, since this was not an error mode
> supported by the old code.

Right, I did notice this but didn't think I was creating a regression
so I left it.  I'll add both a loop and then error out if that fails.

Thanks,
Kent

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 


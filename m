Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2JKNmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:42:49 -0400
Received: from mga06.intel.com ([134.134.136.21]:62101 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753616Ab2JKNmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:42:44 -0400
Message-ID: <1349962956.15966.521.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efivarfs: Implement exclusive access for
 {get,set}_variable
From: Matt Fleming <matt.fleming@intel.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, Matthew Garrett <mjg@redhat.com>
Date: Thu, 11 Oct 2012 14:42:36 +0100
In-Reply-To: <1349961551.174484.910885224391.1.gpush@pecola>
References: <1349961551.174484.910885224391.1.gpush@pecola>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 21:19 +0800, Jeremy Kerr wrote:
> Currently, efivarfs does not enforce exclusion over the get_variable and
> set_variable operations. Section 7.1 of UEFI requires us to only allow a
> single processor to enter {get,set}_variable services at once.
> 
> This change acquires the efivars->lock over calls to these operations
> from the efivarfs paths.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
>  drivers/firmware/efivars.c |   68 +++++++++++++++++++++++--------------
>  1 file changed, 43 insertions(+), 25 deletions(-)

Thanks, applied to 'next'.



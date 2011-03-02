Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1CBGfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 01:35:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61820 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1CBGfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 01:35:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ReiNewhq7B3Fdh3lDZSh++mufKRJrNSZewvPGLDodbEG7kxquxigCvU/KkyMjJpDB6
         uQQl4h8dUNBSmA89dmzmPQt5ktoFKYF4zaeJV2aXjHM089QG4Kuw5wVfHuU/ZYivGIBE
         RrC9QO3wmbDqT7l3i5J70Kz7EfjHboG+uY1gw=
Date: Wed, 2 Mar 2011 09:35:02 +0300
From: Dan Carpenter <error27@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
Message-ID: <20110302063502.GD18043@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	KY Srinivasan <kys@microsoft.com>, Greg KH <greg@kroah.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
References: <1298685930-30806-1-git-send-email-kys@microsoft.com>
 <20110301023449.GC1663@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480165E6@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480165E6@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that everyone reading [patch 1/6] thinks you're renaming
hv_device to vm_device or introducing a new struct vm_device.  That
makes people annoyed.  If you had written the patch description like this:

    In the original code, the structs vm_device included a struct
    hv_device.  This patch moves the members from hv_device directly
    into struct vm_device.

    The members ->dev_type and ->dev_instance from hv_device were
    the same as ->class_id and ->device_id in vm_device so those
    were not copied over.

    Now that everything is included into vm_device directly, 
    hv_device is unused and we can delete the definition.

There still might be issues with the patch, but at least you would be
talking about the same thing.

regards,
dan carpenter

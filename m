Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1COIqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:46:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47086 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab1COIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xGIjeTKMb1W2ggToGvFc0aD2ReTcFzg70vhhLxXZEQoOmL4LIkln2St0JgBEdm52Wf
         xY63HCArtwtRzY/q69vhpzQuVKi3fjUqXnJKYEoc1F0NGCeMmZWoxbVnefV+JKJngmVI
         JZ5CrBm92Lj3XFc8n6NLkwhNF196x2qrMTvGY=
Date: Tue, 15 Mar 2011 11:46:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: wei_wang@realsil.com.cn
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: rts_pstor: set lun_mode in a different
 place
Message-ID: <20110315084625.GU2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	wei_wang@realsil.com.cn, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
References: <1300177336-4486-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300177336-4486-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 04:22:16PM +0800, wei_wang@realsil.com.cn wrote:
> From: wwang <wei_wang@realsil.com.cn>
> 
> In sony notebook, card reader will be configured as two-lun mode
> through EFUSE. In this situation, MS card can't be recognized
> properly because driver does only support single-lun mode in default.
> In this patch, lun_mode is set in a different place, so driver can
> detect the EFUSE configuation automatically.
> 

Hm...  The auto detect code is never run because chip->use_hw_setting is
always 0.  Are you sure the right fix isn't to set chip->use_hw_setting
to 1?

regards,
dan carpenter



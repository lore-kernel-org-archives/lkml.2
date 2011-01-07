Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1AGFbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 00:31:01 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63209 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1AGFbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 00:31:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r4t1EXWnTBHK85dUDykCU06Pm/k3E68TcA9BDIj3yBfiFA4EhY0guYZKnw4yNYBRVh
         Igs+rl7RDi8G+p1U7OMJgf5TbCrObIIvxo7HwCx+GJaJBHqgb3Zy0Ii6grl6C+JnhmBR
         uzhgexkr+qZ7VRHeliLbbxV+1GDY+8MdhmlTU=
Date: Fri, 7 Jan 2011 07:30:54 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] vga_switcheroo: comparing too few characters in
 strncmp()
Message-ID: <20110107053054.GA9057@p183.telecom.by>
References: <20110107051227.GD1717@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107051227.GD1717@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 08:12:27AM +0300, Dan Carpenter wrote:
> This is a copy-and-paste bug.  We should be comparing 4 characters here
> instead of 3.

> --- a/drivers/gpu/vga/vga_switcheroo.c
> +++ b/drivers/gpu/vga/vga_switcheroo.c
> @@ -346,11 +346,11 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
>  	if (strncmp(usercmd, "DIS", 3) == 0)
>  		client_id = VGA_SWITCHEROO_DIS;
>  
> -	if (strncmp(usercmd, "MIGD", 3) == 0) {
> +	if (strncmp(usercmd, "MIGD", 4) == 0) {
>  		just_mux = true;
>  		client_id = VGA_SWITCHEROO_IGD;
>  	}
> -	if (strncmp(usercmd, "MDIS", 3) == 0) {
> +	if (strncmp(usercmd, "MDIS", 4) == 0) {

How about you NUL-terminate, and use strcmp().

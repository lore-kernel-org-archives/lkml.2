Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0DNNuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:50:14 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:41966 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab0DNNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kw50pHUwekWLTRiVq7tQCTpp4DsE5qWymdX7iSb3fPKmUSaKlKdFZQHDFYS6cGZqmo
         leuBsxTICkV8kyIYmGlDkBJrpaC6nmtyYUNDB60Fsw1m35QpvlCh3he+911/lwFh1m3d
         3n1v1h2AfIQooEec7nCr38wo+iEroJ5OzY0ZU=
Date: Wed, 14 Apr 2010 16:50:04 +0300 (EEST)
From: Tero Roponen <tero.roponen@gmail.com>
X-X-Sender: terrop@terrop
To: Luca Tettamanti <kronos.it@gmail.com>
cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       astarikovskiy@suse.de, len.brown@intel.com
Subject: Re: [acpi:battery?] kernel oops on boot
In-Reply-To: <20100414131324.GA6598@nb-core2.darkstar.lan>
Message-ID: <alpine.LFD.2.00.1004141641010.3640@terrop>
References: <20100414095750.GA3304@swordfish.minsk.epam.com> <20100414131324.GA6598@nb-core2.darkstar.lan>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 14 Apr 2010, Luca Tettamanti wrote:

> Hello,
> I'm seeing a similar bug on my notebook (Asus F3Sa) with current git.
> -rc4 does not work, while -rc3 does work.
> 
> The error (at least in my case) is a division by zero in
> acpi_ex_insert_into_field.

I have a similar problem with Asus M50Vm. git-bisect found
the following commit and reverting it does indeed fix the
problem.

commit dadf28a10c3eb29421837a2e413ab869ebd9e168
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Mar 17 13:14:13 2010 -0400

    ACPI: EC: Allow multibyte access to EC
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14667
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

-- 
Tero Roponen

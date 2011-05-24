Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab1EXO0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:26:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37163 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab1EXO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YMGhdA0xHU7VC9Y+4i231WX3dvsxUfPkM4TMOWTLhdFhYBTXBNftL/mwkjGU1a8djF
         aFcupNwqkwKE/ezQ6niZBmVRlt4rki2SrcTbpi+rPp/qjuuntgvGzvyAm23McZgp2zuZ
         ROKrE9Q/aOuKUCftK7gRtai/RalmYj0DQNqJg=
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
From: Hiromu Yakura <hiromu1996@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, zippel@linux-m68k.org
In-Reply-To: <4DDBB150.2090602@suse.cz>
References: <1306167401.18840.8.camel@hiromu-MacBook>
	 <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>
	 <1306242400.7501.10.camel@hiromu-MacBook>  <4DDBB150.2090602@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 23:26:32 +0900
Message-ID: <1306247192.7501.25.camel@hiromu-MacBook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 24, 2011 at 22:23, Michal Marek <mmarek@suse.cz> wrote:
> Arnaud's point is that your patch should not be necessary at all, 
> because kconfig already checks the return value of the fopen() call in 
> conf_write() and prints the above message if it fails. So do you have a 
> testcase where make <...>config without your patch returns without 
> error, but the configuration is not written?
Sorry for misunderstanding.
Indeed, make *config which use 'conf' (e.g. oldconfig, defconfig...)
raise error.
And only xconfig and gconfig don't write the configuration without
error.

However, make *config using 'conf' hasn't function of 'Save as'.
In other words, if you don't set the write permission to the directory,
you would lose changes of the configuration.
I think that it is necessary to check permission at all so that kconfig
warn of the possibility of losing changes.

Thanks




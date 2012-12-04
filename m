Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2LDQjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:39:47 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:43343 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2LDQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:39:45 -0500
Message-ID: <1354639178.12279.6.camel@trivette.mtl.sfl>
Subject: Re: [PATCH RESEND] spi: erase pointer to drvdata on removal
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 04 Dec 2012 11:39:38 -0500
In-Reply-To: <CACxGe6tgMFd8XujkK9qFdkXC_ASA0-2H=vFopkCp+oaFCyTg9A@mail.gmail.com>
References: <1354566504-17657-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <CACxGe6tgMFd8XujkK9qFdkXC_ASA0-2H=vFopkCp+oaFCyTg9A@mail.gmail.com>
Organization: Savoir-faire Linux Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Tue, 2012-12-04 at 14:56 +0000, Grant Likely wrote:
> Instead of clearing the pointer only in the spi code, perhaps the
> checks should be in really_probe() and __device_release_driver() so it
> covers all bus types. Also, don't clear the pointer. Just use
> dev_err() to report on the driver bug so that it gets fixed properly. 

I agree with you. I just figured out that on 2012-05-23, Hans de Goede
added a patch (0998d063) to enforce drvdata to be NULL after
device_release or on probe failure. Good to know.

Thanks,
Vivien


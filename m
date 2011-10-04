Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1JDAu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:50:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46143 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1JDAuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:50:25 -0400
Date: Mon, 3 Oct 2011 17:50:22 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] memory hotplug: Correct page reservation checking
Message-Id: <20111003175022.50cbef7f.akpm00@gmail.com>
In-Reply-To: <4E8098B9.1080702@austin.ibm.com>
References: <4E8098B9.1080702@austin.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 10:22:33 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> The check to ensure that pages of recently added memory sections are correctly
> marked as reserved before trying to online the memory is broken.  The request
> to online the memory fails with the following:
> 
> kernel: section number XXX page number 256 not reserved, was it already online?
> 
> This updates the page reservation checking to check the pages of each memory
> section of the memory block being onlined individually.

Why was this only noticed now?  Is there something unusual about the
way in which you're using it, or has nobody ever used this code, or...?

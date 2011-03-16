Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1CPUQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:16:12 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62635 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1CPUQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cJi4yhDMVEefV2ADnQfbTwESIEt6OYRB9OiPTzI1udUXYqiK9mThZi6P+6RdYjlTqL
         sCZY6ckJ/44+13ttRuXyW+2X8KUAg5jrhwNYDboZnF5WubM7yru27pOFbgNwVYGKWQoI
         4Phwbs2ysDPqk0rnp2wpFQCyFZT3ygc632Ghk=
MIME-Version: 1.0
In-Reply-To: <1300298305-9164-3-git-send-email-robert.richter@amd.com>
References: <1300298305-9164-1-git-send-email-robert.richter@amd.com> <1300298305-9164-3-git-send-email-robert.richter@amd.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Mar 2011 16:15:49 -0400
Message-ID: <AANLkTi=g-Dd957gPxCUfRxVw52T2m6GbswapEAJLnBtP@mail.gmail.com>
Subject: Re: [PATCH 2/2] oprofile: Add __exit attibute to oprofile_arch_exit() functions
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 13:58, Robert Richter wrote:
>  979048e oprofile: don't call arch exit code from init code on failure
>
> we may add __exit attibutes to oprofile_arch_exit() functions.

i dont think this the way to go.  how about updating one place
(include/linux/oprofile.h:oprofile_arch_exit) and making sure all arch
files are including that header if they arent already ?  after all, if
they arent including that header, the arch code could break without
noticing.
-mike

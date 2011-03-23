Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab1CWPaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:30:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55196 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab1CWPaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jMLdKgzN0OpvnYnNfXlIDmlWlNMovsk6KezTrZPQGLWCU8/DVzt9sr9wVrNiF80aDf
         X6YC60ndeFkp5PA3PY+rHHaYrByq1KG/mGZPqp8SttGewtmbo/1LPs3TedfFkXDqCJOn
         Vjym1vwNWAt500BRCa6TeTWZUkdp/WDE1AN20=
MIME-Version: 1.0
In-Reply-To: <1300887554-19031-2-git-send-email-jic23@cam.ac.uk>
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
	<1300887554-19031-2-git-send-email-jic23@cam.ac.uk>
Date: Wed, 23 Mar 2011 17:30:11 +0200
Message-ID: <AANLkTimeEKjVwwYi+twb0oeoFK-33LMx5aQBZEnPodne@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add a kstrtobool function matching semantics of
 existing in kernel equivalents.
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, rusty@rustcorp.com.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 3:39 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> +int kstrtobool(const char *s, bool *res)
> +{
> +       switch (s[0]) {
> +       case 'y':
> +       case 'Y':
> +       case '1':
> +               *res = true;
> +       case 'n':
> +       case 'N':
> +       case '0':
> +               *res = false;
> +       default:
> +               return -EINVAL;
> +       }
> +       return 0;
> +}

sigh... such simple thing and so many bugs

The only values such function should accept is 0 and 1.

Have you read the rest of kstrto*() code?
Where is newline check?

Anyway, I think it's better do not exist.

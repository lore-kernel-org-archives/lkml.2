Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab1KQPHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:07:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab1KQPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:07:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] ramoops: use pstore interface
Date: Thu, 17 Nov 2011 15:07:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ben Gardner <bgardner@wabtec.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
References: <1321478739-8978-1-git-send-email-keescook@chromium.org> <1321478739-8978-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1321478739-8978-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111171507.00699.arnd@arndb.de>
X-Provags-ID: V02:K0:08+OD9utsZCd/e/31+puOg0MbALuHvGOVZy1f+T9wk1
 dJyYjhr1thvwFEHoijxa+YtPz9g+iEYkfYzrza2NVy3e2fqUwj
 S/aMdlumqzRwDOmTf2KGaETwz1O/dcXeLYO2JmG+n2xM1enbtC
 Q7gggP32gaIYILGbrkv0YSxC4tX49WoQq+j6arQTLTLDKIBeXo
 X0YQD2r7lb3a+2E8IkBMR5yCstKvYGKSF+FSCEkzs+d95lZFPL
 a5/noS855u7sOjM1NqlWJsXTOlNvXNWCBCGiiNx+IgPxVvvo+j
 iKuO93pvANQa3SWsynMeLaOlU751cxwK0D4+L2uImu8HScVa95
 k+oq7Gs2ou5S/E6oljj0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 November 2011, Kees Cook wrote:
> Instead of using /dev/mem directly, use the common pstore infrastructure
> to handle Oops gathering and extraction.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Sounds like a very good plan to me. It probably makes sense to move the
entire driver into fs/pstore after this. Otherwise, I have only trivial
style comments:

> +static int ramoops_pstore_open(struct pstore_info *psi);
> +static int ramoops_pstore_close(struct pstore_info *psi);
> +static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
> +				   struct timespec *time,
> +				   char **buf,
> +				   struct pstore_info *psi);
> +static int ramoops_pstore_write(enum pstore_type_id type,
> +				enum kmsg_dump_reason reason, u64 *id,
> +				unsigned int part,
> +				size_t size, struct pstore_info *psi);
> +static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
> +				struct pstore_info *psi);

Can you do it without forward declarations? Many people find code
more readable if it is structure in the natural order that avoids
these.

> +static int ramoops_pstore_close(struct pstore_info *psi)
> +{
> +	return 0;
> +}

Do you actually have to provide this if it's empty?

If yes, it might make sense to change the pstore code so that
it works without a close function.

	Arnd

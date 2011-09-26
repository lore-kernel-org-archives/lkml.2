Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1IZM7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:59:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62810 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1IZM7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <1317037184.2697.1.camel@offbook>
References: <1317037184.2697.1.camel@offbook>
Date: Mon, 26 Sep 2011 20:59:19 +0800
X-Google-Sender-Auth: Nq7dvsLZT8h6EDkaeh5lRbTcKuU
Message-ID: <CAF1ivSbXwb59WjySLrv6ZobqA_H7Jrf8Cq0c3exvVYH69QmKkw@mail.gmail.com>
Subject: Re: [PATCH] ACPI: check mutex release status
From: Lin Ming <ming.m.lin@intel.com>
To: dave@gnu.org
Cc: Len Brown <lenb@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 7:39 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> From: Davidlohr Bueso <dave@gnu.org>
>
> If this is not done we have a bogus ACPI_FAILURE() call.
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  drivers/acpi/acpica/nsload.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/acpica/nsload.c b/drivers/acpi/acpica/nsload.c
> index 5f7dc69..f3070fd 100644
> --- a/drivers/acpi/acpica/nsload.c
> +++ b/drivers/acpi/acpica/nsload.c
> @@ -115,7 +115,7 @@ acpi_ns_load_table(u32 table_index, struct acpi_namespace_node *node)
>        }
>
>       unlock:
> -       (void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
> +       status = acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);

No,

The status maybe set before the "goto unlock" statement.

Lin Ming

>
>        if (ACPI_FAILURE(status)) {
>                return_ACPI_STATUS(status);
> --
> 1.7.4.1

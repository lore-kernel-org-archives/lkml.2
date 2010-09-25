Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab0IYOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 10:16:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65349 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab0IYOQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 10:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qR7ouI3XHX45IyCf62qRxZqljEy4IHnYc6See9PNjt0C4e5JkfaSTmBtcLaTeeSDEq
         3mQGfTW50BJQJpUNfbTej9hPZOSXh7JEM0AvQmNstNoyn7p+7UmqnqPpXKYuWW112ymG
         ApTYfmlEvxAFlVqIb7BjvQyTuh4g3yDMufMo0=
MIME-Version: 1.0
In-Reply-To: <1285422505-7128-1-git-send-email-rahul.ruikar@gmail.com>
References: <1285422505-7128-1-git-send-email-rahul.ruikar@gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Sat, 25 Sep 2010 19:45:10 +0530
Message-ID: <AANLkTik-1noL87D7dnq8AzV9i9BfxYoa-KboAB15r=oT@mail.gmail.com>
Subject: Re: [PATCH] misc: phantom: Added missing warning messages in phantom_probe
To: jirislaby@gmail.com
Cc: ak@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Rahul Ruikar <rahul.ruikar@gmail.com>,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

missed greg in earlier mail.

- Rahul Ruikar





On 25 September 2010 19:18, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> phantom_probe can fail at many places. missing warning messages
> have been added for 2 cases.
> pci_enable_device()
> pci_request_regions()
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/misc/phantom.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
> index 75ee0d3..b4c105f 100644
> --- a/drivers/misc/phantom.c
> +++ b/drivers/misc/phantom.c
> @@ -341,8 +341,10 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
>        int retval;
>
>        retval = pci_enable_device(pdev);
> -       if (retval)
> +       if (retval) {
> +               dev_err(&pdev->dev, "pci_enable_device failed!\n");
>                goto err;
> +       }
>
>        minor = phantom_get_free();
>        if (minor == PHANTOM_MAX_MINORS) {
> @@ -354,8 +356,10 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
>        phantom_devices[minor] = 1;
>
>        retval = pci_request_regions(pdev, "phantom");
> -       if (retval)
> +       if (retval) {
> +               dev_err(&pdev->dev, "pci_request_regions failed!\n");
>                goto err_null;
> +       }
>
>        retval = -ENOMEM;
>        pht = kzalloc(sizeof(*pht), GFP_KERNEL);
> --
> 1.7.2.3
>
>

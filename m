Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2CZUIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:08:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36458 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab2CZUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:08:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 2/6] firmware_class: Split _request_firmware() into three functions
Date: Mon, 26 Mar 2012 22:12:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <4F70B25E.60505@codeaurora.org> <4F70B3B2.7090509@codeaurora.org>
In-Reply-To: <4F70B3B2.7090509@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203262212.36741.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 26, 2012, Stephen Boyd wrote:
> On 03/26/12 11:15, Stephen Boyd wrote:
> > On 03/25/12 15:01, Rafael J. Wysocki wrote:
> >>  drivers/base/firmware_class.c |   57 +++++++++++++++++++++++++++++-------------
> >>  1 file changed, 40 insertions(+), 17 deletions(-)
> >>
> >> Index: linux/drivers/base/firmware_class.c
> >> ===================================================================
> >> --- linux.orig/drivers/base/firmware_class.c
> >> +++ linux/drivers/base/firmware_class.c
> >> @@ -435,7 +435,7 @@ static void firmware_class_timeout(u_lon
> >>  }
> >>  
> >>  static struct firmware_priv *
> >> -fw_create_instance(struct firmware *firmware, const char *fw_name,
> >> +fw_create_instance(const struct firmware *firmware, const char *fw_name,
> >>  		   struct device *device, bool uevent, bool nowait)
> >>  {
> >>  	struct firmware_priv *fw_priv;
> >> @@ -449,7 +449,7 @@ fw_create_instance(struct firmware *firm
> >>  		goto err_out;
> >>  	}
> >>  
> >> -	fw_priv->fw = firmware;
> >> +	fw_priv->fw = (struct firmware *)firmware;
> >>  	fw_priv->nowait = nowait;
> >>  	strcpy(fw_priv->fw_id, fw_name);
> >>  	init_completion(&fw_priv->completion);
> > Can we avoid this cast? If we do some parts of fw_create_instance()
> > during the setup phase I think we can avoid it.
> >
> 
> Oops. With the other patch you can squash this in to do what I
> originally talked about.
> 
> -----8<-----
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index fbe98a8..113d37d 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -435,7 +435,7 @@ static void firmware_class_timeout(u_long data)
>  }
>  
>  static struct firmware_priv *
> -fw_create_instance(const struct firmware *firmware, const char *fw_name,
> +fw_create_instance(struct firmware *firmware, const char *fw_name,
>                    struct device *device, bool uevent, bool nowait)
>  {
>         struct firmware_priv *fw_priv;
> @@ -447,7 +447,7 @@ fw_create_instance(const struct firmware *firmware, const char *fw_name,
>                 return ERR_PTR(-ENOMEM);
>         }
>  
> -       fw_priv->fw = (struct firmware *)firmware;
> +       fw_priv->fw = firmware;
>         fw_priv->nowait = nowait;
>         strcpy(fw_priv->fw_id, fw_name);
>         init_completion(&fw_priv->completion);

Hmm, what other patch?  The one you send previously?

Rafael

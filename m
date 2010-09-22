Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0IVEx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 00:53:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56060 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0IVEx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 00:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uF1KSA1gd2UIw98gHTCukaEMIubCM/ShBXX4+hAzqCNPd72R+3Bf/YPrjgswlp+8hD
         VA9YWaYVNStZEfAP/wxldF3pUaE0cp42Nv8Rg8mJRsrXg4HZTgNbT4xI8tMLicvXAcJl
         aczCAW1ywjP5EvAg+DLF+Tq+/NjLEMVp9CThA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimc3oFBG8YiouuCiJ10hz-V8d-vThmMi56RpV9H@mail.gmail.com>
References: <AANLkTimc3oFBG8YiouuCiJ10hz-V8d-vThmMi56RpV9H@mail.gmail.com>
Date: Wed, 22 Sep 2010 00:53:24 -0400
Message-ID: <AANLkTin0WaY+xXUM59NjAJqVetBK-PDY-g-Hb7zC5Ohx@mail.gmail.com>
Subject: Re: [2.6.36-rc5] minor DRM fixes...
From: Alex Deucher <alexdeucher@gmail.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 12:59 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> Hi Alex; please review and let me know if you prefer this broken out
> further, and thanks.
>

These look good.  Please break them out into separate patches for drm,
ttm, radeon, and vgaarb.

Reviewed By: Alex Deucher <alexdeucher@gmail.com>

> ---
>
> Fix a number of small compilation issues with DRM.
>
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>
> diff --git a/drivers/gpu/drm/drm_buffer.c b/drivers/gpu/drm/drm_buffer.c
> index 55d03ed..687de5f 100644
> --- a/drivers/gpu/drm/drm_buffer.c
> +++ b/drivers/gpu/drm/drm_buffer.c
> @@ -98,7 +98,7 @@ EXPORT_SYMBOL(drm_buffer_alloc);
>  *   user_data: A pointer the data that is copied to the buffer.
>  *   size: The Number of bytes to copy.
>  */
> -extern int drm_buffer_copy_from_user(struct drm_buffer *buf,
> +int drm_buffer_copy_from_user(struct drm_buffer *buf,
>                void __user *user_data, int size)
>  {
>        int nr_pages = size / PAGE_SIZE + 1;
> @@ -163,7 +163,7 @@ void *drm_buffer_read_object(struct drm_buffer *buf,
>  {
>        int idx = drm_buffer_index(buf);
>        int page = drm_buffer_page(buf);
> -       void *obj = 0;
> +       void *obj = NULL;
>
>        if (idx + objsize <= PAGE_SIZE) {
>                obj = &buf->data[page][idx];
> diff --git a/drivers/gpu/drm/radeon/atombios.h
> b/drivers/gpu/drm/radeon/atombios.h
> index 1bc72c3..fe359a2 100644
> --- a/drivers/gpu/drm/radeon/atombios.h
> +++ b/drivers/gpu/drm/radeon/atombios.h
> @@ -4999,7 +4999,7 @@ typedef struct _SW_I2C_IO_DATA_PARAMETERS
>  #define SW_I2C_CNTL_WRITE1BIT 6
>
>  //==============================VESA definition
> Portion===============================
> -#define VESA_OEM_PRODUCT_REV                               '01.00'
> +#define VESA_OEM_PRODUCT_REV                               "01.00"
>  #define VESA_MODE_ATTRIBUTE_MODE_SUPPORT            0xBB       //refer to VBE
> spec p.32, no TTY support
>  #define VESA_MODE_WIN_ATTRIBUTE                                                     7
>  #define VESA_WIN_SIZE                                                                                       64
> diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
> index bfdfa3e..e3b47a5 100644
> --- a/drivers/gpu/drm/radeon/r600.c
> +++ b/drivers/gpu/drm/radeon/r600.c
> @@ -2727,7 +2727,7 @@ int r600_ib_test(struct radeon_device *rdev)
>        if (i < rdev->usec_timeout) {
>                DRM_INFO("ib test succeeded in %u usecs\n", i);
>        } else {
> -               DRM_ERROR("radeon: ib test failed (sracth(0x%04X)=0x%08X)\n",
> +               DRM_ERROR("radeon: ib test failed (scratch(0x%04X)=0x%08X)\n",
>                          scratch, tmp);
>                r = -EINVAL;
>        }
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> index ca90479..b1e02ff 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> @@ -69,7 +69,7 @@ struct ttm_page_pool {
>        spinlock_t              lock;
>        bool                    fill_lock;
>        struct list_head        list;
> -       int                     gfp_flags;
> +       gfp_t                   gfp_flags;
>        unsigned                npages;
>        char                    *name;
>        unsigned long           nfrees;
> @@ -475,7 +475,7 @@ static void
> ttm_handle_caching_state_failure(struct list_head *pages,
>  * This function is reentrant if caller updates count depending on number of
>  * pages returned in pages array.
>  */
> -static int ttm_alloc_new_pages(struct list_head *pages, int gfp_flags,
> +static int ttm_alloc_new_pages(struct list_head *pages, gfp_t gfp_flags,
>                int ttm_flags, enum ttm_caching_state cstate, unsigned count)
>  {
>        struct page **caching_array;
> @@ -666,7 +666,7 @@ int ttm_get_pages(struct list_head *pages, int flags,
>  {
>        struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
>        struct page *p = NULL;
> -       int gfp_flags = GFP_USER;
> +       gfp_t gfp_flags = GFP_USER;
>        int r;
>
>        /* set zero flag for page allocation if required */
> @@ -818,7 +818,7 @@ int ttm_page_alloc_init(struct ttm_mem_global
> *glob, unsigned max_pages)
>        return 0;
>  }
>
> -void ttm_page_alloc_fini()
> +void ttm_page_alloc_fini(void)
>  {
>        int i;
>
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index b87569e..f366f96 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -598,7 +598,7 @@ static inline void
> vga_update_device_decodes(struct vga_device *vgadev,
>        pr_debug("vgaarb: decoding count now is: %d\n", vga_decode_count);
>  }
>
> -void __vga_set_legacy_decoding(struct pci_dev *pdev, unsigned int
> decodes, bool userspace)
> +static void __vga_set_legacy_decoding(struct pci_dev *pdev, unsigned
> int decodes, bool userspace)
>  {
>        struct vga_device *vgadev;
>        unsigned long flags;
> --
> Daniel J Blueman
>

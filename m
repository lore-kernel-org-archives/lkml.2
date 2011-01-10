Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1AJVBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:01:24 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4079 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1AJVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:01:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [RFC V9 3/7] drivers:media:radio: wl128x: FM Driver Common  sources
Date: Mon, 10 Jan 2011 22:01:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-tschai; KDE/4.4.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1294664700-26949-1-git-send-email-manjunatha_halli@ti.com> <1294664700-26949-3-git-send-email-manjunatha_halli@ti.com> <1294664700-26949-4-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1294664700-26949-4-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101102201.12318.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manjunatha,

Thanks for all the work, it looks much better now!

I found a few little things here, but otherwise you can stick a

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

tag in the whole driver series.

On Monday, January 10, 2011 14:04:56 manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> These are the sources for the common interfaces required by the
> FM V4L2 driver for TI WL127x and WL128x chips.
> 
> These implement the FM channel-8 protocol communication with the
> chip. This makes use of the Shared Transport as its transport.
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> ---
>  drivers/media/radio/wl128x/fmdrv_common.c | 1693 +++++++++++++++++++++++++++++
>  drivers/media/radio/wl128x/fmdrv_common.h |  402 +++++++
>  2 files changed, 2095 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_common.c
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_common.h
> 
> diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
> new file mode 100644
> index 0000000..46f5fe4
> --- /dev/null
> +++ b/drivers/media/radio/wl128x/fmdrv_common.c

<snip>

> +u32 fmc_set_freq(struct fmdev *fmdev, u32 freq_to_set)
> +{
> +	switch (fmdev->curr_fmmode) {
> +	case FM_MODE_RX:
> +		return fm_rx_set_freq(fmdev, freq_to_set);
> +		break;

'break' after a 'return' can be removed. This is repeated several times.

> +
> +	case FM_MODE_TX:
> +		return fm_tx_set_freq(fmdev, freq_to_set);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +u32 fmc_get_freq(struct fmdev *fmdev, u32 *cur_tuned_frq)
> +{
> +	if (fmdev->rx.freq == FM_UNDEFINED_FREQ) {
> +		fmerr("RX frequency is not set\n");
> +		return -EPERM;
> +	}
> +	if (cur_tuned_frq == NULL) {
> +		fmerr("Invalid memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	switch (fmdev->curr_fmmode) {
> +	case FM_MODE_RX:
> +		*cur_tuned_frq = fmdev->rx.freq;
> +		break;
> +
> +	case FM_MODE_TX:
> +		*cur_tuned_frq = 0;	/* TODO : Change this later */
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +u32 fmc_set_region(struct fmdev *fmdev, u8 region_to_set)
> +{
> +	switch (fmdev->curr_fmmode) {
> +	case FM_MODE_RX:
> +		return fm_rx_set_region(fmdev, region_to_set);
> +		break;
> +
> +	case FM_MODE_TX:
> +		return fm_tx_set_region(fmdev, region_to_set);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +u32 fmc_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
> +{
> +	switch (fmdev->curr_fmmode) {
> +	case FM_MODE_RX:
> +		return fm_rx_set_mute_mode(fmdev, mute_mode_toset);
> +		break;
> +
> +	case FM_MODE_TX:
> +		return fm_tx_set_mute_mode(fmdev, mute_mode_toset);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +u32 fmc_set_stereo_mono(struct fmdev *fmdev, u16 mode)
> +{
> +	switch (fmdev->curr_fmmode) {
> +	case FM_MODE_RX:
> +		return fm_rx_set_stereo_mono(fmdev, mode);
> +		break;
> +
> +	case FM_MODE_TX:
> +		return fm_tx_set_stereo_mono(fmdev, mode);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +u32 fmc_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
> +{
> +	switch (fmdev->curr_fmmode) {
> +	case FM_MODE_RX:
> +		return fm_rx_set_rds_mode(fmdev, rds_en_dis);
> +		break;
> +
> +	case FM_MODE_TX:
> +		return fm_tx_set_rds_mode(fmdev, rds_en_dis);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +/* Sends power off command to the chip */
> +static u32 fm_power_down(struct fmdev *fmdev)
> +{
> +	u16 payload;
> +	u32 ret = 0;
> +
> +	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
> +		fmerr("FM core is not ready\n");
> +		return -EPERM;
> +	}
> +	if (fmdev->curr_fmmode == FM_MODE_OFF) {
> +		fmdbg("FM chip is already in OFF state\n");
> +		return ret;
> +	}
> +
> +	payload = 0x0;
> +	ret = fmc_send_cmd(fmdev, FM_POWER_MODE, REG_WR, &payload,
> +		sizeof(payload), NULL, NULL);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = fmc_release(fmdev);

Just do 'return fmc_release(fmdev);' here.

> +
> +	return ret;
> +}
> +
> +/* Reads init command from FM firmware file and loads to the chip */
> +static u32 fm_download_firmware(struct fmdev *fmdev, const u8 *fw_name)
> +{
> +	const struct firmware *fw_entry;
> +	struct bts_header *fw_header;
> +	struct bts_action *action;
> +	struct bts_action_delay *delay;
> +	u8 *fw_data;
> +	int ret, fw_len, cmd_cnt;
> +
> +	cmd_cnt = 0;
> +	set_bit(FM_FW_DW_INPROGRESS, &fmdev->flag);
> +
> +	ret = request_firmware(&fw_entry, fw_name,
> +				&fmdev->radio_dev->dev);
> +	if (ret < 0) {
> +		fmerr("Unable to read firmware(%s) content\n", fw_name);
> +		return ret;
> +	}
> +	fmdbg("Firmware(%s) length : %d bytes\n", fw_name, fw_entry->size);
> +
> +	fw_data = (void *)fw_entry->data;
> +	fw_len = fw_entry->size;
> +
> +	fw_header = (struct bts_header *)fw_data;
> +	if (fw_header->magic != FM_FW_FILE_HEADER_MAGIC) {
> +		fmerr("%s not a legal TI firmware file\n", fw_name);
> +		ret = -EINVAL;
> +		goto rel_fw;
> +	}
> +	fmdbg("FW(%s) magic number : 0x%x\n", fw_name, fw_header->magic);
> +
> +	/* Skip file header info , we already verified it */
> +	fw_data += sizeof(struct bts_header);
> +	fw_len -= sizeof(struct bts_header);
> +
> +	while (fw_data && fw_len > 0) {
> +		action = (struct bts_action *)fw_data;
> +
> +		switch (action->type) {
> +		case ACTION_SEND_COMMAND:	/* Send */
> +			if (fmc_send_cmd(fmdev, 0, 0, action->data,
> +						action->size, NULL, NULL))
> +				goto rel_fw;
> +
> +			cmd_cnt++;
> +			break;
> +
> +		case ACTION_DELAY:	/* Delay */
> +			delay = (struct bts_action_delay *)action->data;
> +			mdelay(delay->msec);
> +			break;
> +		}
> +
> +		fw_data += (sizeof(struct bts_action) + (action->size));
> +		fw_len -= (sizeof(struct bts_action) + (action->size));
> +	}
> +	fmdbg("Firmare commands(%d) loaded to chip\n", cmd_cnt);

Firmare -> Firmware

> +rel_fw:
> +	release_firmware(fw_entry);
> +	clear_bit(FM_FW_DW_INPROGRESS, &fmdev->flag);
> +
> +	return ret;
> +}

<snip>

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

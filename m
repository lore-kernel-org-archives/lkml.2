Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2IAPF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 11:05:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52968 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2IAPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 11:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <1346506980-2868-1-git-send-email-yamanetoshi@gmail.com>
References: <1346506980-2868-1-git-send-email-yamanetoshi@gmail.com>
Date: Sat, 1 Sep 2012 20:35:22 +0530
Message-ID: <CAHdPZaPjE2Fc3eBk=_zzAqgtmdoWxkqN9RW3eN99CDh_CQKnbA@mail.gmail.com>
Subject: Re: [PATCH] staging/rts_pstor: remove braces {} in sd.c
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a very big patch. It will be difficult for reviewers to review.

i think it will be good if you can split into multiple patches.

Thanks,

On Sat, Sep 1, 2012 at 7:13 PM, Toshiaki Yamane <yamanetoshi@gmail.com> wrote:
> fixed below checkpatch warnings.
> -WARNING: braces {} are not necessary for single statement blocks
> -WARNING: braces {} are not necessary for any arm of this statement
>
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
> ---
>  drivers/staging/rts_pstor/sd.c | 1112 +++++++++++++++++-----------------------
>  1 file changed, 469 insertions(+), 643 deletions(-)
>
> diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
> index 3cc9a48..6a2df19 100644
> --- a/drivers/staging/rts_pstor/sd.c
> +++ b/drivers/staging/rts_pstor/sd.c
> @@ -192,9 +192,9 @@ RTY_SEND_CMD:
>
>                 stat_idx = 16;
>         } else if (rsp_type != SD_RSP_TYPE_R0) {
> -               for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++) {
> +               for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++)
>                         rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
> -               }
> +
>                 stat_idx = 5;
>         }
>
> @@ -273,9 +273,8 @@ RTY_SEND_CMD:
>         if ((rsp_type == SD_RSP_TYPE_R1) || (rsp_type == SD_RSP_TYPE_R1b)) {
>                 if ((cmd_idx != SEND_RELATIVE_ADDR) && (cmd_idx != SEND_IF_COND)) {
>                         if (cmd_idx != STOP_TRANSMISSION) {
> -                               if (ptr[1] & 0x80) {
> +                               if (ptr[1] & 0x80)
>                                         TRACE_RET(chip, STATUS_FAIL);
> -                               }
>                         }
>  #ifdef SUPPORT_SD_LOCK
>                         if (ptr[1] & 0x7D)
> @@ -294,11 +293,10 @@ RTY_SEND_CMD:
>                                 RTSX_DEBUGP("ptr[3]: 0x%02x\n", ptr[3]);
>                                 TRACE_RET(chip, STATUS_FAIL);
>                         }
> -                       if (ptr[3] & 0x01) {
> +                       if (ptr[3] & 0x01)
>                                 sd_card->sd_data_buf_ready = 1;
> -                       } else {
> +                       else
>                                 sd_card->sd_data_buf_ready = 0;
> -                       }
>                 }
>         }
>
> @@ -322,17 +320,15 @@ static int sd_read_data(struct rtsx_chip *chip,
>         if (!buf)
>                 buf_len = 0;
>
> -       if (buf_len > 512) {
> +       if (buf_len > 512)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         rtsx_init_cmd(chip);
>
>         if (cmd_len) {
>                 RTSX_DEBUGP("SD/MMC CMD %d\n", cmd[0] - 0x40);
> -               for (i = 0; i < (cmd_len < 6 ? cmd_len : 6); i++) {
> +               for (i = 0; i < (cmd_len < 6 ? cmd_len : 6); i++)
>                         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CMD0 + i, 0xFF, cmd[i]);
> -               }
>         }
>         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BYTE_CNT_L, 0xFF, (u8)byte_cnt);
>         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BYTE_CNT_H, 0xFF, (u8)(byte_cnt >> 8));
> @@ -344,9 +340,9 @@ static int sd_read_data(struct rtsx_chip *chip,
>         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG2, 0xFF,
>                         SD_CALCULATE_CRC7 | SD_CHECK_CRC16 | SD_NO_WAIT_BUSY_END |
>                         SD_CHECK_CRC7 | SD_RSP_LEN_6);
> -       if (trans_mode != SD_TM_AUTO_TUNING) {
> +       if (trans_mode != SD_TM_AUTO_TUNING)
>                 rtsx_add_cmd(chip, WRITE_REG_CMD, CARD_DATA_SOURCE, 0x01, PINGPONG_BUFFER);
> -       }
> +
>         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_TRANSFER, 0xFF, trans_mode | SD_TRANSFER_START);
>         rtsx_add_cmd(chip, CHECK_REG_CMD, REG_SD_TRANSFER, SD_TRANSFER_END, SD_TRANSFER_END);
>
> @@ -362,9 +358,8 @@ static int sd_read_data(struct rtsx_chip *chip,
>
>         if (buf && buf_len) {
>                 retval = rtsx_read_ppbuf(chip, buf, buf_len);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>         }
>
>         return STATUS_SUCCESS;
> @@ -390,9 +385,8 @@ static int sd_write_data(struct rtsx_chip *chip, u8 trans_mode,
>
>         if (buf && buf_len) {
>                 retval = rtsx_write_ppbuf(chip, buf, buf_len);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>         }
>
>         rtsx_init_cmd(chip);
> @@ -450,15 +444,13 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
>                         break;
>         }
>
> -       if (i == 6) {
> +       if (i == 6)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         memcpy(sd_card->raw_csd, rsp + 1, 15);
>
> -       if (CHECK_PID(chip, 0x5209)) {
> +       if (CHECK_PID(chip, 0x5209))
>                 RTSX_READ_REG(chip, REG_SD_CMD5, sd_card->raw_csd + 15);
> -       }
>
>         RTSX_DEBUGP("CSD Response:\n");
>         RTSX_DUMP(sd_card->raw_csd, 16);
> @@ -469,35 +461,35 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
>         trans_speed = rsp[4];
>         if ((trans_speed & 0x07) == 0x02) {
>                 if ((trans_speed & 0xf8) >= 0x30) {
> -                       if (chip->asic_code) {
> +                       if (chip->asic_code)
>                                 sd_card->sd_clock = 47;
> -                       } else {
> +                       else
>                                 sd_card->sd_clock = CLK_50;
> -                       }
> +
>                 } else if ((trans_speed & 0xf8) == 0x28) {
> -                       if (chip->asic_code) {
> +                       if (chip->asic_code)
>                                 sd_card->sd_clock = 39;
> -                       } else {
> +                       else
>                                 sd_card->sd_clock = CLK_40;
> -                       }
> +
>                 } else if ((trans_speed & 0xf8) == 0x20) {
> -                       if (chip->asic_code) {
> +                       if (chip->asic_code)
>                                 sd_card->sd_clock = 29;
> -                       } else {
> +                       else
>                                 sd_card->sd_clock = CLK_30;
> -                       }
> +
>                 } else if ((trans_speed & 0xf8) >= 0x10) {
> -                       if (chip->asic_code) {
> +                       if (chip->asic_code)
>                                 sd_card->sd_clock = 23;
> -                       } else {
> +                       else
>                                 sd_card->sd_clock = CLK_20;
> -                       }
> +
>                 } else if ((trans_speed & 0x08) >= 0x08) {
> -                       if (chip->asic_code) {
> +                       if (chip->asic_code)
>                                 sd_card->sd_clock = 19;
> -                       } else {
> +                       else
>                                 sd_card->sd_clock = CLK_20;
> -                       }
> +
>                 } else {
>                         TRACE_RET(chip, STATUS_FAIL);
>                 }
> @@ -527,9 +519,9 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
>         }
>
>         if (check_wp) {
> -               if (rsp[15] & 0x30) {
> +               if (rsp[15] & 0x30)
>                         chip->card_wp |= SD_CARD;
> -               }
> +
>                 RTSX_DEBUGP("CSD WP Status: 0x%x\n", rsp[15]);
>         }
>
> @@ -568,22 +560,22 @@ static int sd_set_sample_push_timing(struct rtsx_chip *chip)
>                                         CRC_FIX_CLK | SD30_VAR_CLK0 | SAMPLE_VAR_CLK1);
>                         RTSX_WRITE_REG(chip, CLK_CTL, CLK_LOW_FREQ, 0);
>
> -                       if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_AUTO) {
> +                       if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_AUTO)
>                                 val = SD20_TX_NEG_EDGE;
> -                       } else if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_DELAY) {
> +                       else if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_DELAY)
>                                 val = SD20_TX_14_AHEAD;
> -                       } else {
> +                       else
>                                 val = SD20_TX_NEG_EDGE;
> -                       }
> +
>                         RTSX_WRITE_REG(chip, SD_PUSH_POINT_CTL, SD20_TX_SEL_MASK, val);
>
>                         if ((chip->sd_ctl & SD_SAMPLE_POINT_CTL_MASK) == SD_SAMPLE_POINT_AUTO) {
>                                 if (chip->asic_code) {
> -                                       if (CHK_SD_HS(sd_card) || CHK_MMC_52M(sd_card)) {
> +                                       if (CHK_SD_HS(sd_card) || CHK_MMC_52M(sd_card))
>                                                 val = SD20_RX_14_DELAY;
> -                                       } else {
> +                                       else
>                                                 val = SD20_RX_POS_EDGE;
> -                                       }
> +
>                                 } else {
>                                         val = SD20_RX_14_DELAY;
>                                 }
> @@ -597,32 +589,28 @@ static int sd_set_sample_push_timing(struct rtsx_chip *chip)
>         } else {
>                 u8 val = 0;
>
> -               if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_DELAY) {
> +               if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_DELAY)
>                         val |= 0x10;
> -               }
>
>                 if ((chip->sd_ctl & SD_SAMPLE_POINT_CTL_MASK) == SD_SAMPLE_POINT_AUTO) {
>                         if (chip->asic_code) {
>                                 if (CHK_SD_HS(sd_card) || CHK_MMC_52M(sd_card)) {
> -                                       if (val & 0x10) {
> +                                       if (val & 0x10)
>                                                 val |= 0x04;
> -                                       } else {
> +                                       else
>                                                 val |= 0x08;
> -                                       }
>                                 }
>                         } else {
> -                               if (val & 0x10) {
> +                               if (val & 0x10)
>                                         val |= 0x04;
> -                               } else {
> +                               else
>                                         val |= 0x08;
> -                               }
>                         }
>                 } else if ((chip->sd_ctl & SD_SAMPLE_POINT_CTL_MASK) == SD_SAMPLE_POINT_DELAY) {
> -                       if (val & 0x10) {
> +                       if (val & 0x10)
>                                 val |= 0x04;
> -                       } else {
> +                       else
>                                 val |= 0x08;
> -                       }
>                 }
>
>                 RTSX_WRITE_REG(chip, REG_SD_CFG1, 0x1C, val);
> @@ -636,41 +624,41 @@ static void sd_choose_proper_clock(struct rtsx_chip *chip)
>         struct sd_info *sd_card = &(chip->sd_card);
>
>         if (CHK_SD_SDR104(sd_card)) {
> -               if (chip->asic_code) {
> +               if (chip->asic_code)
>                         sd_card->sd_clock = chip->asic_sd_sdr104_clk;
> -               } else {
> +               else
>                         sd_card->sd_clock = chip->fpga_sd_sdr104_clk;
> -               }
> +
>         } else if (CHK_SD_DDR50(sd_card)) {
> -               if (chip->asic_code) {
> +               if (chip->asic_code)
>                         sd_card->sd_clock = chip->asic_sd_ddr50_clk;
> -               } else {
> +               else
>                         sd_card->sd_clock = chip->fpga_sd_ddr50_clk;
> -               }
> +
>         } else if (CHK_SD_SDR50(sd_card)) {
> -               if (chip->asic_code) {
> +               if (chip->asic_code)
>                         sd_card->sd_clock = chip->asic_sd_sdr50_clk;
> -               } else {
> +               else
>                         sd_card->sd_clock = chip->fpga_sd_sdr50_clk;
> -               }
> +
>         } else if (CHK_SD_HS(sd_card)) {
> -               if (chip->asic_code) {
> +               if (chip->asic_code)
>                         sd_card->sd_clock = chip->asic_sd_hs_clk;
> -               } else {
> +               else
>                         sd_card->sd_clock = chip->fpga_sd_hs_clk;
> -               }
> +
>         } else if (CHK_MMC_52M(sd_card) || CHK_MMC_DDR52(sd_card)) {
> -               if (chip->asic_code) {
> +               if (chip->asic_code)
>                         sd_card->sd_clock = chip->asic_mmc_52m_clk;
> -               } else {
> +               else
>                         sd_card->sd_clock = chip->fpga_mmc_52m_clk;
> -               }
> +
>         } else if (CHK_MMC_26M(sd_card)) {
> -               if (chip->asic_code) {
> +               if (chip->asic_code)
>                         sd_card->sd_clock = 48;
> -               } else {
> +               else
>                         sd_card->sd_clock = CLK_50;
> -               }
> +
>         }
>  }
>
> @@ -683,13 +671,12 @@ static int sd_set_clock_divider(struct rtsx_chip *chip, u8 clk_div)
>                 val = clk_div;
>         } else {
>                 mask = 0x60;
> -               if (clk_div == SD_CLK_DIVIDE_0) {
> +               if (clk_div == SD_CLK_DIVIDE_0)
>                         val = 0x00;
> -               } else if (clk_div == SD_CLK_DIVIDE_128) {
> +               else if (clk_div == SD_CLK_DIVIDE_128)
>                         val = 0x40;
> -               } else if (clk_div == SD_CLK_DIVIDE_256) {
> +               else if (clk_div == SD_CLK_DIVIDE_256)
>                         val = 0x20;
> -               }
>         }
>
>         RTSX_WRITE_REG(chip, REG_SD_CFG1, mask, val);
> @@ -703,16 +690,14 @@ static int sd_set_init_para(struct rtsx_chip *chip)
>         int retval;
>
>         retval = sd_set_sample_push_timing(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         sd_choose_proper_clock(chip);
>
>         retval = switch_clock(chip, sd_card->sd_clock);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -735,9 +720,8 @@ int sd_select_card(struct rtsx_chip *chip, int select)
>         }
>
>         retval = sd_send_cmd_get_rsp(chip, cmd_idx, addr, cmd_type, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -750,21 +734,18 @@ static int sd_update_lock_status(struct rtsx_chip *chip)
>         u8 rsp[5];
>
>         retval = sd_send_cmd_get_rsp(chip, SEND_STATUS, sd_card->sd_addr, SD_RSP_TYPE_R1, rsp, 5);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
> -       if (rsp[1] & 0x02) {
> +       if (rsp[1] & 0x02)
>                 sd_card->sd_lock_status |= SD_LOCKED;
> -       } else {
> +       else
>                 sd_card->sd_lock_status &= ~SD_LOCKED;
> -       }
>
>         RTSX_DEBUGP("sd_card->sd_lock_status = 0x%x\n", sd_card->sd_lock_status);
>
> -       if (rsp[1] & 0x01) {
> +       if (rsp[1] & 0x01)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -779,13 +760,12 @@ static int sd_wait_state_data_ready(struct rtsx_chip *chip, u8 state, u8 data_re
>         for (i = 0; i < polling_cnt; i++) {
>                 retval = sd_send_cmd_get_rsp(chip, SEND_STATUS,
>                                              sd_card->sd_addr, SD_RSP_TYPE_R1, rsp, 5);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
> -               if (((rsp[3] & 0x1E) == state) && ((rsp[3] & 0x01) == data_ready)) {
> +               if (((rsp[3] & 0x1E) == state) && ((rsp[3] & 0x01) == data_ready))
>                         return STATUS_SUCCESS;
> -               }
> +
>         }
>
>         TRACE_RET(chip, STATUS_FAIL);
> @@ -798,18 +778,16 @@ static int sd_change_bank_voltage(struct rtsx_chip *chip, u8 voltage)
>         if (voltage == SD_IO_3V3) {
>                 if (chip->asic_code) {
>                         retval = rtsx_write_phy_register(chip, 0x08, 0x4FC0 | chip->phy_voltage);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
>                 } else {
>                         RTSX_WRITE_REG(chip, SD_PAD_CTL, SD_IO_USING_1V8, 0);
>                 }
>         } else if (voltage == SD_IO_1V8) {
>                 if (chip->asic_code) {
>                         retval = rtsx_write_phy_register(chip, 0x08, 0x4C40 | chip->phy_voltage);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
>                 } else {
>                         RTSX_WRITE_REG(chip, SD_PAD_CTL, SD_IO_USING_1V8, SD_IO_USING_1V8);
>                 }
> @@ -828,9 +806,8 @@ static int sd_voltage_switch(struct rtsx_chip *chip)
>         RTSX_WRITE_REG(chip, SD_BUS_STAT, SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, SD_CLK_TOGGLE_EN);
>
>         retval = sd_send_cmd_get_rsp(chip, VOLTAGE_SWITCH, 0, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         udelay(chip->sd_voltage_switch_delay);
>
> @@ -842,9 +819,9 @@ static int sd_voltage_switch(struct rtsx_chip *chip)
>
>         RTSX_WRITE_REG(chip, SD_BUS_STAT, 0xFF, SD_CLK_FORCE_STOP);
>         retval = sd_change_bank_voltage(chip, SD_IO_1V8);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
> +
>         wait_timeout(50);
>
>         RTSX_WRITE_REG(chip, SD_BUS_STAT, 0xFF, SD_CLK_TOGGLE_EN);
> @@ -893,9 +870,8 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
>         if (tune_dir == TUNE_RX) {
>                 SD_VP_CTL = SD_VPRX_CTL;
>                 SD_DCMPS_CTL = SD_DCMPS_RX_CTL;
> -               if (CHK_SD_DDR50(sd_card)) {
> +               if (CHK_SD_DDR50(sd_card))
>                         ddr_rx = 1;
> -               }
>         } else {
>                 SD_VP_CTL = SD_VPTX_CTL;
>                 SD_DCMPS_CTL = SD_DCMPS_TX_CTL;
> @@ -932,23 +908,22 @@ static int sd_change_phase(struct rtsx_chip *chip, u8 sample_point, u8 tune_dir)
>                 rtsx_add_cmd(chip, WRITE_REG_CMD, SD_DCMPS_CTL, DCMPS_CHANGE, DCMPS_CHANGE);
>                 rtsx_add_cmd(chip, CHECK_REG_CMD, SD_DCMPS_CTL, DCMPS_CHANGE_DONE, DCMPS_CHANGE_DONE);
>                 retval = rtsx_send_cmd(chip, SD_CARD, 100);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, Fail);
> -               }
>
>                 val = *rtsx_get_cmd_data(chip);
> -               if (val & DCMPS_ERROR) {
> +               if (val & DCMPS_ERROR)
>                         TRACE_GOTO(chip, Fail);
> -               }
> -               if ((val & DCMPS_CURRENT_PHASE) != sample_point) {
> +
> +               if ((val & DCMPS_CURRENT_PHASE) != sample_point)
>                         TRACE_GOTO(chip, Fail);
> -               }
> +
>                 RTSX_WRITE_REG(chip, SD_DCMPS_CTL, DCMPS_CHANGE, 0);
> -               if (ddr_rx) {
> +               if (ddr_rx)
>                         RTSX_WRITE_REG(chip, SD_VP_CTL, PHASE_CHANGE, 0);
> -               } else {
> +               else
>                         RTSX_WRITE_REG(chip, CLK_CTL, CHANGE_CLK, 0);
> -               }
> +
>                 udelay(50);
>         }
>
> @@ -978,9 +953,8 @@ static int sd_check_spec(struct rtsx_chip *chip, u8 bus_width)
>         u8 cmd[5], buf[8];
>
>         retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         cmd[0] = 0x40 | SEND_SCR;
>         cmd[1] = 0;
> @@ -996,9 +970,8 @@ static int sd_check_spec(struct rtsx_chip *chip, u8 bus_width)
>
>         memcpy(sd_card->raw_scr, buf, 8);
>
> -       if ((buf[0] & 0x0F) == 0) {
> +       if ((buf[0] & 0x0F) == 0)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -1172,13 +1145,12 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
>                  */
>                 u16 cc = ((u16)buf[0] << 8) | buf[1];
>                 RTSX_DEBUGP("Maximum current consumption: %dmA\n", cc);
> -               if ((cc == 0) || (cc > 800)) {
> +               if ((cc == 0) || (cc > 800))
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>                 retval = sd_query_switch_result(chip, func_group, func_to_switch, buf, 64);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 if ((cc > 400) || (func_to_switch > CURRENT_LIMIT_400)) {
>                         RTSX_WRITE_REG(chip, OCPPARA2, SD_OCP_THD_MASK, chip->sd_800mA_ocp_thd);
> @@ -1192,13 +1164,13 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
>  static u8 downgrade_switch_mode(u8 func_group, u8 func_to_switch)
>  {
>         if (func_group == SD_FUNC_GROUP_1) {
> -               if (func_to_switch > HS_SUPPORT) {
> +               if (func_to_switch > HS_SUPPORT)
>                         func_to_switch--;
> -               }
> +
>         } else if (func_group == SD_FUNC_GROUP_4) {
> -               if (func_to_switch > CURRENT_LIMIT_200) {
> +               if (func_to_switch > CURRENT_LIMIT_200)
>                         func_to_switch--;
> -               }
> +
>         }
>
>         return func_to_switch;
> @@ -1241,9 +1213,8 @@ static int sd_check_switch(struct rtsx_chip *chip,
>                 wait_timeout(20);
>         }
>
> -       if (!switch_good) {
> +       if (!switch_good)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -1258,9 +1229,8 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
>         /* Get supported functions */
>         retval = sd_check_switch_mode(chip, SD_CHECK_MODE,
>                         NO_ARGUMENT, NO_ARGUMENT, bus_width);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         sd_card->func_group1_mask &= ~(sd_card->sd_switch_fail);
>
> @@ -1289,9 +1259,9 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
>                         break;
>
>                 case HS_SUPPORT:
> -                       if (sd_card->func_group1_mask & HS_SUPPORT_MASK) {
> +                       if (sd_card->func_group1_mask & HS_SUPPORT_MASK)
>                                 func_to_switch = HS_SUPPORT;
> -                       }
> +
>                         break;
>
>                 default:
> @@ -1299,9 +1269,9 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
>                 }
>
>
> -               if (func_to_switch) {
> +               if (func_to_switch)
>                         break;
> -               }
> +
>         }
>         RTSX_DEBUGP("SD_FUNC_GROUP_1: func_to_switch = 0x%02x", func_to_switch);
>
> @@ -1330,23 +1300,22 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
>                         TRACE_RET(chip, STATUS_FAIL);
>                 }
>
> -               if (func_to_switch == SDR104_SUPPORT) {
> +               if (func_to_switch == SDR104_SUPPORT)
>                         SET_SD_SDR104(sd_card);
> -               } else if (func_to_switch == DDR50_SUPPORT) {
> +               else if (func_to_switch == DDR50_SUPPORT)
>                         SET_SD_DDR50(sd_card);
> -               } else if (func_to_switch == SDR50_SUPPORT) {
> +               else if (func_to_switch == SDR50_SUPPORT)
>                         SET_SD_SDR50(sd_card);
> -               } else {
> +               else
>                         SET_SD_HS(sd_card);
> -               }
> +
>         }
>
>         if (CHK_SD_DDR50(sd_card)) {
>                 RTSX_WRITE_REG(chip, SD_PUSH_POINT_CTL, 0x06, 0x04);
>                 retval = sd_set_sample_push_timing(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>         }
>
>         if (!func_to_switch || (func_to_switch == HS_SUPPORT)) {
> @@ -1362,36 +1331,36 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
>         for (i = 0; i < 4; i++) {
>                 switch ((u8)(chip->sd_current_prior >> (i*8))) {
>                 case CURRENT_LIMIT_800:
> -                       if (sd_card->func_group4_mask & CURRENT_LIMIT_800_MASK) {
> +                       if (sd_card->func_group4_mask & CURRENT_LIMIT_800_MASK)
>                                 func_to_switch = CURRENT_LIMIT_800;
> -                       }
> +
>                         break;
>
>                 case CURRENT_LIMIT_600:
> -                       if (sd_card->func_group4_mask & CURRENT_LIMIT_600_MASK) {
> +                       if (sd_card->func_group4_mask & CURRENT_LIMIT_600_MASK)
>                                 func_to_switch = CURRENT_LIMIT_600;
> -                       }
> +
>                         break;
>
>                 case CURRENT_LIMIT_400:
> -                       if (sd_card->func_group4_mask & CURRENT_LIMIT_400_MASK) {
> +                       if (sd_card->func_group4_mask & CURRENT_LIMIT_400_MASK)
>                                 func_to_switch = CURRENT_LIMIT_400;
> -                       }
> +
>                         break;
>
>                 case CURRENT_LIMIT_200:
> -                       if (sd_card->func_group4_mask & CURRENT_LIMIT_200_MASK) {
> +                       if (sd_card->func_group4_mask & CURRENT_LIMIT_200_MASK)
>                                 func_to_switch = CURRENT_LIMIT_200;
> -                       }
> +
>                         break;
>
>                 default:
>                         continue;
>                 }
>
> -               if (func_to_switch != 0xFF) {
> +               if (func_to_switch != 0xFF)
>                         break;
> -               }
> +
>         }
>
>         RTSX_DEBUGP("SD_FUNC_GROUP_4: func_to_switch = 0x%02x", func_to_switch);
> @@ -1399,16 +1368,15 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
>         if (func_to_switch <= CURRENT_LIMIT_800) {
>                 retval = sd_check_switch(chip, SD_FUNC_GROUP_4, func_to_switch, bus_width);
>                 if (retval != STATUS_SUCCESS) {
> -                       if (sd_check_err_code(chip, SD_NO_CARD)) {
> +                       if (sd_check_err_code(chip, SD_NO_CARD))
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
> +
>                 }
>                 RTSX_DEBUGP("Switch current limit finished! (%d)\n", retval);
>         }
>
> -       if (CHK_SD_DDR50(sd_card)) {
> +       if (CHK_SD_DDR50(sd_card))
>                 RTSX_WRITE_REG(chip, SD_PUSH_POINT_CTL, 0x06, 0);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -1438,9 +1406,8 @@ static int sd_sdr_tuning_rx_cmd(struct rtsx_chip *chip, u8 sample_point)
>         u8 cmd[5];
>
>         retval = sd_change_phase(chip, sample_point, TUNE_RX);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         cmd[0] = 0x40 | SEND_TUNING_PATTERN;
>         cmd[1] = 0;
> @@ -1467,16 +1434,14 @@ static int sd_ddr_tuning_rx_cmd(struct rtsx_chip *chip, u8 sample_point)
>         u8 cmd[5];
>
>         retval = sd_change_phase(chip, sample_point, TUNE_RX);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         RTSX_DEBUGP("sd ddr tuning rx\n");
>
>         retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         cmd[0] = 0x40 | SD_STATUS;
>         cmd[1] = 0;
> @@ -1502,18 +1467,16 @@ static int mmc_ddr_tunning_rx_cmd(struct rtsx_chip *chip, u8 sample_point)
>         int retval;
>         u8 cmd[5], bus_width;
>
> -       if (CHK_MMC_8BIT(sd_card)) {
> +       if (CHK_MMC_8BIT(sd_card))
>                 bus_width = SD_BUS_WIDTH_8;
> -       } else if (CHK_MMC_4BIT(sd_card)) {
> +       else if (CHK_MMC_4BIT(sd_card))
>                 bus_width = SD_BUS_WIDTH_4;
> -       } else {
> +       else
>                 bus_width = SD_BUS_WIDTH_1;
> -       }
>
>         retval = sd_change_phase(chip, sample_point, TUNE_RX);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         RTSX_DEBUGP("mmc ddr tuning rx\n");
>
> @@ -1541,9 +1504,8 @@ static int sd_sdr_tuning_tx_cmd(struct rtsx_chip *chip, u8 sample_point)
>         int retval;
>
>         retval = sd_change_phase(chip, sample_point, TUNE_TX);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         RTSX_WRITE_REG(chip, SD_CFG3, SD_RSP_80CLK_TIMEOUT_EN, SD_RSP_80CLK_TIMEOUT_EN);
>
> @@ -1568,26 +1530,23 @@ static int sd_ddr_tuning_tx_cmd(struct rtsx_chip *chip, u8 sample_point)
>         u8 cmd[5], bus_width;
>
>         retval = sd_change_phase(chip, sample_point, TUNE_TX);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (CHK_SD(sd_card)) {
>                 bus_width = SD_BUS_WIDTH_4;
>         } else {
> -               if (CHK_MMC_8BIT(sd_card)) {
> +               if (CHK_MMC_8BIT(sd_card))
>                         bus_width = SD_BUS_WIDTH_8;
> -               } else if (CHK_MMC_4BIT(sd_card)) {
> +               else if (CHK_MMC_4BIT(sd_card))
>                         bus_width = SD_BUS_WIDTH_4;
> -               } else {
> +               else
>                         bus_width = SD_BUS_WIDTH_1;
> -               }
>         }
>
>         retval = sd_wait_state_data_ready(chip, 0x08, 1, 1000);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         RTSX_WRITE_REG(chip, SD_CFG3, SD_RSP_80CLK_TIMEOUT_EN, SD_RSP_80CLK_TIMEOUT_EN);
>
> @@ -1621,11 +1580,10 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map, u8 tune_d
>         u8 final_phase = 0xFF;
>
>         if (phase_map == 0xFFFFFFFF) {
> -               if (tune_dir == TUNE_RX) {
> +               if (tune_dir == TUNE_RX)
>                         final_phase = (u8)chip->sd_default_rx_phase;
> -               } else {
> +               else
>                         final_phase = (u8)chip->sd_default_tx_phase;
> -               }
>
>                 goto Search_Finish;
>         }
> @@ -1666,9 +1624,9 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map, u8 tune_d
>                 path[0].start = path[cont_path_cnt - 1].start - MAX_PHASE - 1;
>                 path[0].len += path[cont_path_cnt - 1].len;
>                 path[0].mid = path[0].start + path[0].len / 2;
> -               if (path[0].mid < 0) {
> +               if (path[0].mid < 0)
>                         path[0].mid += MAX_PHASE + 1;
> -               }
> +
>                 cont_path_cnt--;
>         }
>
> @@ -1696,11 +1654,11 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map, u8 tune_d
>                                 int temp_final_phase =
>                                         path[final_path_idx].end - (max_len - (6 + temp_mid));
>
> -                               if (temp_final_phase < 0) {
> +                               if (temp_final_phase < 0)
>                                         final_phase = (u8)(temp_final_phase + MAX_PHASE + 1);
> -                               } else {
> +                               else
>                                         final_phase = (u8)temp_final_phase;
> -                               }
> +
>                         }
>                 } else if (CHK_SD_SDR50(sd_card)) {
>                         if (max_len > 12) {
> @@ -1708,11 +1666,11 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map, u8 tune_d
>                                 int temp_final_phase =
>                                         path[final_path_idx].end - (max_len - (3 + temp_mid));
>
> -                               if (temp_final_phase < 0) {
> +                               if (temp_final_phase < 0)
>                                         final_phase = (u8)(temp_final_phase + MAX_PHASE + 1);
> -                               } else {
> +                               else
>                                         final_phase = (u8)temp_final_phase;
> -                               }
> +
>                         }
>                 }
>         }
> @@ -1732,17 +1690,17 @@ static int sd_tuning_rx(struct rtsx_chip *chip)
>         int (*tuning_cmd)(struct rtsx_chip *chip, u8 sample_point);
>
>         if (CHK_SD(sd_card)) {
> -               if (CHK_SD_DDR50(sd_card)) {
> +               if (CHK_SD_DDR50(sd_card))
>                         tuning_cmd = sd_ddr_tuning_rx_cmd;
> -               } else {
> +               else
>                         tuning_cmd = sd_sdr_tuning_rx_cmd;
> -               }
> +
>         } else {
> -               if (CHK_MMC_DDR52(sd_card)) {
> +               if (CHK_MMC_DDR52(sd_card))
>                         tuning_cmd = mmc_ddr_tunning_rx_cmd;
> -               } else {
> +               else
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         }
>
>         for (i = 0; i < 3; i++) {
> @@ -1754,27 +1712,25 @@ static int sd_tuning_rx(struct rtsx_chip *chip)
>                         }
>
>                         retval = tuning_cmd(chip, (u8)j);
> -                       if (retval == STATUS_SUCCESS) {
> +                       if (retval == STATUS_SUCCESS)
>                                 raw_phase_map[i] |= 1 << j;
> -                       }
> +
>                 }
>         }
>
>         phase_map = raw_phase_map[0] & raw_phase_map[1] & raw_phase_map[2];
> -       for (i = 0; i < 3; i++) {
> +       for (i = 0; i < 3; i++)
>                 RTSX_DEBUGP("RX raw_phase_map[%d] = 0x%08x\n", i, raw_phase_map[i]);
> -       }
> +
>         RTSX_DEBUGP("RX phase_map = 0x%08x\n", phase_map);
>
>         final_phase = sd_search_final_phase(chip, phase_map, TUNE_RX);
> -       if (final_phase == 0xFF) {
> +       if (final_phase == 0xFF)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_change_phase(chip, final_phase, TUNE_RX);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -1799,15 +1755,14 @@ static int sd_ddr_pre_tuning_tx(struct rtsx_chip *chip)
>                 }
>
>                 retval = sd_change_phase(chip, (u8)i, TUNE_TX);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         continue;
> -               }
>
>                 retval = sd_send_cmd_get_rsp(chip, SEND_STATUS, sd_card->sd_addr,
>                                 SD_RSP_TYPE_R1, NULL, 0);
> -               if ((retval == STATUS_SUCCESS) || !sd_check_err_code(chip, SD_RSP_TIMEOUT)) {
> +               if ((retval == STATUS_SUCCESS) || !sd_check_err_code(chip, SD_RSP_TIMEOUT))
>                         phase_map |= 1 << i;
> -               }
> +
>         }
>
>         RTSX_WRITE_REG(chip, SD_CFG3, SD_RSP_80CLK_TIMEOUT_EN, 0);
> @@ -1815,14 +1770,12 @@ static int sd_ddr_pre_tuning_tx(struct rtsx_chip *chip)
>         RTSX_DEBUGP("DDR TX pre tune phase_map = 0x%08x\n", phase_map);
>
>         final_phase = sd_search_final_phase(chip, phase_map, TUNE_TX);
> -       if (final_phase == 0xFF) {
> +       if (final_phase == 0xFF)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_change_phase(chip, final_phase, TUNE_TX);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         RTSX_DEBUGP("DDR TX pre tune phase: %d\n", (int)final_phase);
>
> @@ -1839,17 +1792,17 @@ static int sd_tuning_tx(struct rtsx_chip *chip)
>         int (*tuning_cmd)(struct rtsx_chip *chip, u8 sample_point);
>
>         if (CHK_SD(sd_card)) {
> -               if (CHK_SD_DDR50(sd_card)) {
> +               if (CHK_SD_DDR50(sd_card))
>                         tuning_cmd = sd_ddr_tuning_tx_cmd;
> -               } else {
> +               else
>                         tuning_cmd = sd_sdr_tuning_tx_cmd;
> -               }
> +
>         } else {
> -               if (CHK_MMC_DDR52(sd_card)) {
> +               if (CHK_MMC_DDR52(sd_card))
>                         tuning_cmd = sd_ddr_tuning_tx_cmd;
> -               } else {
> +               else
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         }
>
>         for (i = 0; i < 3; i++) {
> @@ -1863,27 +1816,25 @@ static int sd_tuning_tx(struct rtsx_chip *chip)
>                         }
>
>                         retval = tuning_cmd(chip, (u8)j);
> -                       if (retval == STATUS_SUCCESS) {
> +                       if (retval == STATUS_SUCCESS)
>                                 raw_phase_map[i] |= 1 << j;
> -                       }
> +
>                 }
>         }
>
>         phase_map = raw_phase_map[0] & raw_phase_map[1] & raw_phase_map[2];
> -       for (i = 0; i < 3; i++) {
> +       for (i = 0; i < 3; i++)
>                 RTSX_DEBUGP("TX raw_phase_map[%d] = 0x%08x\n", i, raw_phase_map[i]);
> -       }
> +
>         RTSX_DEBUGP("TX phase_map = 0x%08x\n", phase_map);
>
>         final_phase = sd_search_final_phase(chip, phase_map, TUNE_TX);
> -       if (final_phase == 0xFF) {
> +       if (final_phase == 0xFF)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_change_phase(chip, final_phase, TUNE_TX);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -1893,14 +1844,12 @@ static int sd_sdr_tuning(struct rtsx_chip *chip)
>         int retval;
>
>         retval = sd_tuning_tx(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_tuning_rx(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -1911,26 +1860,25 @@ static int sd_ddr_tuning(struct rtsx_chip *chip)
>
>         if (!(chip->sd_ctl & SD_DDR_TX_PHASE_SET_BY_USER)) {
>                 retval = sd_ddr_pre_tuning_tx(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         } else {
>                 retval = sd_change_phase(chip, (u8)chip->sd_ddr_tx_phase, TUNE_TX);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         }
>
>         retval = sd_tuning_rx(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (!(chip->sd_ctl & SD_DDR_TX_PHASE_SET_BY_USER)) {
>                 retval = sd_tuning_tx(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         }
>
>         return STATUS_SUCCESS;
> @@ -1942,26 +1890,25 @@ static int mmc_ddr_tuning(struct rtsx_chip *chip)
>
>         if (!(chip->sd_ctl & MMC_DDR_TX_PHASE_SET_BY_USER)) {
>                 retval = sd_ddr_pre_tuning_tx(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         } else {
>                 retval = sd_change_phase(chip, (u8)chip->mmc_ddr_tx_phase, TUNE_TX);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         }
>
>         retval = sd_tuning_rx(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (!(chip->sd_ctl & MMC_DDR_TX_PHASE_SET_BY_USER)) {
>                 retval = sd_tuning_tx(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         }
>
>         return STATUS_SUCCESS;
> @@ -1974,9 +1921,8 @@ int sd_switch_clock(struct rtsx_chip *chip)
>         int re_tuning = 0;
>
>         retval = select_card(chip, SD_CARD);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (CHECK_PID(chip, 0x5209) &&
>                         (CHK_SD30_SPEED(sd_card) || CHK_MMC_DDR52(sd_card))) {
> @@ -1987,26 +1933,25 @@ int sd_switch_clock(struct rtsx_chip *chip)
>         }
>
>         retval = switch_clock(chip, sd_card->sd_clock);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (re_tuning) {
>                 if (CHK_SD(sd_card)) {
> -                       if (CHK_SD_DDR50(sd_card)) {
> +                       if (CHK_SD_DDR50(sd_card))
>                                 retval = sd_ddr_tuning(chip);
> -                       } else {
> +                       else
>                                 retval = sd_sdr_tuning(chip);
> -                       }
> +
>                 } else {
> -                       if (CHK_MMC_DDR52(sd_card)) {
> +                       if (CHK_MMC_DDR52(sd_card))
>                                 retval = mmc_ddr_tuning(chip);
> -                       }
> +
>                 }
>
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         }
>
>         return STATUS_SUCCESS;
> @@ -2017,11 +1962,10 @@ static int sd_prepare_reset(struct rtsx_chip *chip)
>         struct sd_info *sd_card = &(chip->sd_card);
>         int retval;
>
> -       if (chip->asic_code) {
> +       if (chip->asic_code)
>                 sd_card->sd_clock = 29;
> -       } else {
> +       else
>                 sd_card->sd_clock = CLK_30;
> -       }
>
>         sd_card->sd_type = 0;
>         sd_card->seq_mode = 0;
> @@ -2037,9 +1981,8 @@ static int sd_prepare_reset(struct rtsx_chip *chip)
>         chip->sd_io = 0;
>
>         retval = sd_set_init_para(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, retval);
> -       }
>
>         if (CHECK_PID(chip, 0x5209)) {
>                 RTSX_WRITE_REG(chip, REG_SD_CFG1, 0xFF,
> @@ -2053,9 +1996,8 @@ static int sd_prepare_reset(struct rtsx_chip *chip)
>         RTSX_WRITE_REG(chip, CARD_STOP, SD_STOP | SD_CLR_ERR, SD_STOP | SD_CLR_ERR);
>
>         retval = select_card(chip, SD_CARD);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -2122,9 +2064,8 @@ int sd_pull_ctl_enable(struct rtsx_chip *chip)
>         }
>
>         retval = rtsx_send_cmd(chip, SD_CARD, 100);
> -       if (retval < 0) {
> +       if (retval < 0)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -2133,42 +2074,38 @@ static int sd_init_power(struct rtsx_chip *chip)
>  {
>         int retval;
>
> -       if (CHECK_PID(chip, 0x5209)) {
> +       if (CHECK_PID(chip, 0x5209))
>                 RTSX_WRITE_REG(chip, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_OFF);
> -       }
>
>         retval = sd_power_off_card3v3(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
> -       if (!chip->ft2_fast_mode) {
> +       if (!chip->ft2_fast_mode)
>                 wait_timeout(250);
> -       }
>
>         retval = enable_card_clock(chip, SD_CARD);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (chip->asic_code) {
>                 retval = sd_pull_ctl_enable(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         } else {
>                 RTSX_WRITE_REG(chip, FPGA_PULL_CTL, FPGA_SD_PULL_CTL_BIT | 0x20, 0);
>         }
>
>         if (chip->ft2_fast_mode) {
> -               if (CHECK_PID(chip, 0x5209)) {
> +               if (CHECK_PID(chip, 0x5209))
>                         RTSX_WRITE_REG(chip, PWR_GATE_CTRL, LDO3318_PWR_MASK, LDO_ON);
> -               }
> +
>         } else {
>                 retval = card_power_on(chip, SD_CARD);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>                 wait_timeout(260);
>
>  #ifdef SUPPORT_OCP
> @@ -2214,13 +2151,13 @@ static int sd_read_lba0(struct rtsx_chip *chip)
>         if (CHK_SD(sd_card)) {
>                 bus_width = SD_BUS_WIDTH_4;
>         } else {
> -               if (CHK_MMC_8BIT(sd_card)) {
> +               if (CHK_MMC_8BIT(sd_card))
>                         bus_width = SD_BUS_WIDTH_8;
> -               } else if (CHK_MMC_4BIT(sd_card)) {
> +               else if (CHK_MMC_4BIT(sd_card))
>                         bus_width = SD_BUS_WIDTH_4;
> -               } else {
> +               else
>                         bus_width = SD_BUS_WIDTH_1;
> -               }
> +
>         }
>
>         retval = sd_read_data(chip, SD_TM_NORMAL_READ, cmd,
> @@ -2243,9 +2180,8 @@ static int sd_check_wp_state(struct rtsx_chip *chip)
>
>         retval = sd_send_cmd_get_rsp(chip, APP_CMD,
>                         sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         cmd[0] = 0x40 | SD_STATUS;
>         cmd[1] = 0;
> @@ -2273,9 +2209,8 @@ static int sd_check_wp_state(struct rtsx_chip *chip)
>
>         /* Check SD Machanical Write-Protect Switch */
>         val = rtsx_readl(chip, RTSX_BIPR);
> -       if (val & SD_WRITE_PROTECT) {
> +       if (val & SD_WRITE_PROTECT)
>                 chip->card_wp |= SD_CARD;
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -2307,14 +2242,12 @@ Switch_Fail:
>  #endif
>
>         retval = sd_prepare_reset(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_dummy_clock(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip) && try_sdio) {
>                 int rty_cnt = 0;
> @@ -2348,9 +2281,8 @@ Switch_Fail:
>         /* Start Initialization Process of SD Card */
>  RTY_SD_RST:
>         retval = sd_send_cmd_get_rsp(chip, GO_IDLE_STATE, 0, SD_RSP_TYPE_R0, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         wait_timeout(20);
>
> @@ -2377,9 +2309,8 @@ RTY_SD_RST:
>                 voltage = SUPPORT_VOLTAGE;
>
>                 retval = sd_send_cmd_get_rsp(chip, GO_IDLE_STATE, 0, SD_RSP_TYPE_R0, NULL, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                        TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 wait_timeout(20);
>         }
> @@ -2393,42 +2324,41 @@ RTY_SD_RST:
>                         }
>
>                         j++;
> -                       if (j < 3) {
> +                       if (j < 3)
>                                 goto RTY_SD_RST;
> -                       } else {
> +                       else
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
> +
>                 }
>
>                 retval = sd_send_cmd_get_rsp(chip, SD_APP_OP_COND, voltage, SD_RSP_TYPE_R3, rsp, 5);
>                 if (retval != STATUS_SUCCESS) {
>                         k++;
> -                       if (k < 3) {
> +                       if (k < 3)
>                                 goto RTY_SD_RST;
> -                       } else {
> +                       else
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
> +
>                 }
>
>                 i++;
>                 wait_timeout(20);
>         } while (!(rsp[1] & 0x80) && (i < 255));
>
> -       if (i == 255) {
> +       if (i == 255)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (hi_cap_flow) {
> -               if (rsp[1] & 0x40) {
> +               if (rsp[1] & 0x40)
>                         SET_SD_HCXC(sd_card);
> -               } else {
> +               else
>                         CLR_SD_HCXC(sd_card);
> -               }
> -               if (CHECK_PID(chip, 0x5209) && CHK_SD_HCXC(sd_card) && !sd20_mode) {
> +
> +               if (CHECK_PID(chip, 0x5209) && CHK_SD_HCXC(sd_card) && !sd20_mode)
>                         support_1v8 = (rsp[1] & 0x01) ? 1 : 0;
> -               } else {
> +               else
>                         support_1v8 = 0;
> -               }
> +
>         } else {
>                 CLR_SD_HCXC(sd_card);
>                 support_1v8 = 0;
> @@ -2437,46 +2367,40 @@ RTY_SD_RST:
>
>         if (support_1v8) {
>                 retval = sd_voltage_switch(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>         }
>
>         retval = sd_send_cmd_get_rsp(chip, ALL_SEND_CID, 0, SD_RSP_TYPE_R2, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         for (i = 0; i < 3; i++) {
>                 retval = sd_send_cmd_get_rsp(chip, SEND_RELATIVE_ADDR, 0, SD_RSP_TYPE_R6, rsp, 5);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 sd_card->sd_addr = (u32)rsp[1] << 24;
>                 sd_card->sd_addr += (u32)rsp[2] << 16;
>
> -               if (sd_card->sd_addr) {
> +               if (sd_card->sd_addr)
>                         break;
> -               }
> +
>         }
>
>         retval = sd_check_csd(chip, 1);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_select_card(chip, 1);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>  #ifdef SUPPORT_SD_LOCK
>  SD_UNLOCK_ENTRY:
>         retval = sd_update_lock_status(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (sd_card->sd_lock_status & SD_LOCKED) {
>                 sd_card->sd_lock_status |= (SD_LOCK_1BIT_MODE | SD_PWD_EXIST);
> @@ -2487,23 +2411,21 @@ SD_UNLOCK_ENTRY:
>  #endif
>
>         retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
> +
>         retval = sd_send_cmd_get_rsp(chip, SET_CLR_CARD_DETECT, 0, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (support_1v8) {
>                 retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>                 retval = sd_send_cmd_get_rsp(chip, SET_BUS_WIDTH, 2, SD_RSP_TYPE_R1, NULL, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 switch_bus_width = SD_BUS_WIDTH_4;
>         } else {
> @@ -2511,14 +2433,12 @@ SD_UNLOCK_ENTRY:
>         }
>
>         retval = sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, 0x200, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (!(sd_card->raw_csd[4] & 0x40))
>                 sd_dont_switch = 1;
> @@ -2537,9 +2457,9 @@ SD_UNLOCK_ENTRY:
>                 if (retval == STATUS_SUCCESS) {
>                         retval = sd_switch_function(chip, switch_bus_width);
>                         if (retval != STATUS_SUCCESS) {
> -                               if (CHECK_PID(chip, 0x5209)) {
> +                               if (CHECK_PID(chip, 0x5209))
>                                         sd_change_bank_voltage(chip, SD_IO_3V3);
> -                               }
> +
>                                 sd_init_power(chip);
>                                 sd_dont_switch = 1;
>                                 try_sdio = 0;
> @@ -2548,9 +2468,9 @@ SD_UNLOCK_ENTRY:
>                         }
>                 } else {
>                         if (support_1v8) {
> -                               if (CHECK_PID(chip, 0x5209)) {
> +                               if (CHECK_PID(chip, 0x5209))
>                                         sd_change_bank_voltage(chip, SD_IO_3V3);
> -                               }
> +
>                                 sd_init_power(chip);
>                                 sd_dont_switch = 1;
>                                 try_sdio = 0;
> @@ -2562,13 +2482,13 @@ SD_UNLOCK_ENTRY:
>
>         if (!support_1v8) {
>                 retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>                 retval = sd_send_cmd_get_rsp(chip, SET_BUS_WIDTH, 2, SD_RSP_TYPE_R1, NULL, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
> +
>         }
>
>  #ifdef SUPPORT_SD_LOCK
> @@ -2581,24 +2501,22 @@ SD_UNLOCK_ENTRY:
>                 RTSX_WRITE_REG(chip, SD30_DRIVE_SEL, 0x07, chip->sd30_drive_sel_1v8);
>
>                 retval = sd_set_init_para(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
> -               if (CHK_SD_DDR50(sd_card)) {
> +               if (CHK_SD_DDR50(sd_card))
>                         retval = sd_ddr_tuning(chip);
> -               } else {
> +               else
>                         retval = sd_sdr_tuning(chip);
> -               }
>
>                 if (retval != STATUS_SUCCESS) {
>                         if (sd20_mode) {
>                                 TRACE_RET(chip, STATUS_FAIL);
>                         } else {
>                                 retval = sd_init_power(chip);
> -                               if (retval != STATUS_SUCCESS) {
> +                               if (retval != STATUS_SUCCESS)
>                                         TRACE_RET(chip, STATUS_FAIL);
> -                               }
> +
>                                 try_sdio = 0;
>                                 sd20_mode = 1;
>                                 goto Switch_Fail;
> @@ -2609,9 +2527,9 @@ SD_UNLOCK_ENTRY:
>
>                 if (CHK_SD_DDR50(sd_card)) {
>                         retval = sd_wait_state_data_ready(chip, 0x08, 1, 1000);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 read_lba0 = 0;
> -                       }
> +
>                 }
>
>                 if (read_lba0) {
> @@ -2621,9 +2539,9 @@ SD_UNLOCK_ENTRY:
>                                         TRACE_RET(chip, STATUS_FAIL);
>                                 } else {
>                                         retval = sd_init_power(chip);
> -                                       if (retval != STATUS_SUCCESS) {
> +                                       if (retval != STATUS_SUCCESS)
>                                                 TRACE_RET(chip, STATUS_FAIL);
> -                                       }
> +
>                                         try_sdio = 0;
>                                         sd20_mode = 1;
>                                         goto Switch_Fail;
> @@ -2633,9 +2551,8 @@ SD_UNLOCK_ENTRY:
>         }
>
>         retval = sd_check_wp_state(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         chip->card_bus_width[chip->card2lun[SD_CARD]] = 4;
>
> @@ -2659,9 +2576,8 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
>         int len;
>
>         retval = sd_send_cmd_get_rsp(chip, BUSTEST_W, 0, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, SWITCH_FAIL);
> -       }
>
>         if (width == MMC_8BIT_BUS) {
>                 buf[0] = 0x55;
> @@ -2690,9 +2606,9 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
>                         rtsx_read_register(chip, REG_SD_STAT1, &val1);
>                         rtsx_read_register(chip, REG_SD_STAT2, &val2);
>                         rtsx_clear_sd_error(chip);
> -                       if ((val1 & 0xE0) || val2) {
> +                       if ((val1 & 0xE0) || val2)
>                                 TRACE_RET(chip, SWITCH_ERR);
> -                       }
> +
>                 } else {
>                         rtsx_clear_sd_error(chip);
>                         rtsx_write_register(chip, REG_SD_CFG3, 0x02, 0);
> @@ -2712,11 +2628,10 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
>
>         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CMD0, 0xFF, 0x40 | BUSTEST_R);
>
> -       if (width == MMC_8BIT_BUS) {
> +       if (width == MMC_8BIT_BUS)
>                 rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BYTE_CNT_L, 0xFF, 0x08);
> -       } else {
> +       else
>                 rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BYTE_CNT_L, 0xFF, 0x04);
> -       }
>
>         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BLOCK_CNT_L, 0xFF, 1);
>         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_BLOCK_CNT_H, 0xFF, 0);
> @@ -2729,15 +2644,13 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
>         rtsx_add_cmd(chip, CHECK_REG_CMD, REG_SD_TRANSFER, SD_TRANSFER_END, SD_TRANSFER_END);
>
>         rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2, 0, 0);
> -       if (width == MMC_8BIT_BUS) {
> +       if (width == MMC_8BIT_BUS)
>                 rtsx_add_cmd(chip, READ_REG_CMD, PPBUF_BASE2 + 1, 0, 0);
> -       }
>
>         retval = rtsx_send_cmd(chip, SD_CARD, 100);
> -       if (retval < 0) {
> +       if (retval < 0)
>                 rtsx_clear_sd_error(chip);
>                 TRACE_RET(chip, SWITCH_ERR);
> -       }
>
>         ptr = rtsx_get_cmd_data(chip) + 1;
>
> @@ -2747,15 +2660,15 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
>                         u8 rsp[5];
>                         u32 arg;
>
> -                       if (CHK_MMC_DDR52(sd_card)) {
> +                       if (CHK_MMC_DDR52(sd_card))
>                                 arg = 0x03B70600;
> -                       } else {
> +                       else
>                                 arg = 0x03B70200;
> -                       }
> +
>                         retval = sd_send_cmd_get_rsp(chip, SWITCH, arg, SD_RSP_TYPE_R1b, rsp, 5);
> -                       if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR)) {
> +                       if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR))
>                                 return SWITCH_SUCCESS;
> -                       }
> +
>                 }
>         } else {
>                 RTSX_DEBUGP("BUSTEST_R [4bits]: 0x%02x\n", ptr[0]);
> @@ -2763,15 +2676,15 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
>                         u8 rsp[5];
>                         u32 arg;
>
> -                       if (CHK_MMC_DDR52(sd_card)) {
> +                       if (CHK_MMC_DDR52(sd_card))
>                                 arg = 0x03B70500;
> -                       } else {
> +                       else
>                                 arg = 0x03B70100;
> -                       }
> +
>                         retval = sd_send_cmd_get_rsp(chip, SWITCH, arg, SD_RSP_TYPE_R1b, rsp, 5);
> -                       if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR)) {
> +                       if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR))
>                                 return SWITCH_SUCCESS;
> -                       }
> +
>                 }
>         }
>
> @@ -2845,11 +2758,10 @@ static int mmc_switch_timing_bus(struct rtsx_chip *chip, int switch_ddr)
>                         card_type_mask = 0x03;
>                 }
>  #else
> -               if (chip->sd_ctl & SUPPORT_MMC_DDR_MODE) {
> +               if (chip->sd_ctl & SUPPORT_MMC_DDR_MODE)
>                         card_type_mask = 0x07;
> -               } else {
> +               else
>                         card_type_mask = 0x03;
> -               }
>  #endif
>         } else {
>                 card_type_mask = 0x03;
> @@ -2859,11 +2771,11 @@ static int mmc_switch_timing_bus(struct rtsx_chip *chip, int switch_ddr)
>                 u8 rsp[5];
>
>                 if (card_type & 0x04) {
> -                       if (switch_ddr) {
> +                       if (switch_ddr)
>                                 SET_MMC_DDR52(sd_card);
> -                       } else {
> +                       else
>                                 SET_MMC_52M(sd_card);
> -                       }
> +
>                 } else if (card_type & 0x02) {
>                         SET_MMC_52M(sd_card);
>                 } else {
> @@ -2872,16 +2784,15 @@ static int mmc_switch_timing_bus(struct rtsx_chip *chip, int switch_ddr)
>
>                 retval = sd_send_cmd_get_rsp(chip, SWITCH,
>                                 0x03B90100, SD_RSP_TYPE_R1b, rsp, 5);
> -               if ((retval != STATUS_SUCCESS) || (rsp[4] & MMC_SWITCH_ERR)) {
> +               if ((retval != STATUS_SUCCESS) || (rsp[4] & MMC_SWITCH_ERR))
>                         CLR_MMC_HS(sd_card);
> -               }
> +
>         }
>
>         sd_choose_proper_clock(chip);
>         retval = switch_clock(chip, sd_card->sd_clock);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         /* Test Bus Procedure */
>         retval = mmc_test_switch_bus(chip, MMC_8BIT_BUS);
> @@ -2929,17 +2840,15 @@ static int reset_mmc(struct rtsx_chip *chip)
>
>  Switch_Fail:
>         retval = sd_prepare_reset(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, retval);
> -       }
>
>         SET_MMC(sd_card);
>
>  RTY_MMC_RST:
>         retval = sd_send_cmd_get_rsp(chip, GO_IDLE_STATE, 0, SD_RSP_TYPE_R0, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> -              TRACE_RET(chip, STATUS_FAIL);
> -       }
> +       if (retval != STATUS_SUCCESS)
> +               TRACE_RET(chip, STATUS_FAIL);
>
>         do {
>                 if (detect_card_cd(chip, SD_CARD) != STATUS_SUCCESS) {
> @@ -2973,56 +2882,47 @@ RTY_MMC_RST:
>                 i++;
>         } while (!(rsp[1] & 0x80) && (i < 255));
>
> -       if (i == 255) {
> +       if (i == 255)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
> -       if ((rsp[1] & 0x60) == 0x40) {
> +       if ((rsp[1] & 0x60) == 0x40)
>                 SET_MMC_SECTOR_MODE(sd_card);
> -       } else {
> +       else
>                 CLR_MMC_SECTOR_MODE(sd_card);
> -       }
>
>         retval = sd_send_cmd_get_rsp(chip, ALL_SEND_CID, 0, SD_RSP_TYPE_R2, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         sd_card->sd_addr = 0x00100000;
>         retval = sd_send_cmd_get_rsp(chip, SET_RELATIVE_ADDR, sd_card->sd_addr, SD_RSP_TYPE_R6, rsp, 5);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_check_csd(chip, 1);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         spec_ver = (sd_card->raw_csd[0] & 0x3C) >> 2;
>
>         retval = sd_select_card(chip, 1);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, 0x200, SD_RSP_TYPE_R1, NULL, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>  #ifdef SUPPORT_SD_LOCK
>  MMC_UNLOCK_ENTRY:
>         retval = sd_update_lock_status(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>  #endif
>
>         retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         chip->card_bus_width[chip->card2lun[SD_CARD]] = 1;
>
> @@ -3039,22 +2939,20 @@ MMC_UNLOCK_ENTRY:
>                         }
>                 }
>
> -               if (CHK_MMC_SECTOR_MODE(sd_card) && (sd_card->capacity == 0)) {
> +               if (CHK_MMC_SECTOR_MODE(sd_card) && (sd_card->capacity == 0))
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 if (switch_ddr && CHK_MMC_DDR52(sd_card)) {
>                         retval = sd_set_init_para(chip);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
>
>                         retval = mmc_ddr_tuning(chip);
>                         if (retval != STATUS_SUCCESS) {
>                                 retval = sd_init_power(chip);
> -                               if (retval != STATUS_SUCCESS) {
> +                               if (retval != STATUS_SUCCESS)
>                                         TRACE_RET(chip, STATUS_FAIL);
> -                               }
> +
>                                 switch_ddr = 0;
>                                 TRACE_GOTO(chip, Switch_Fail);
>                         }
> @@ -3064,9 +2962,9 @@ MMC_UNLOCK_ENTRY:
>                                 retval = sd_read_lba0(chip);
>                                 if (retval != STATUS_SUCCESS) {
>                                         retval = sd_init_power(chip);
> -                                       if (retval != STATUS_SUCCESS) {
> +                                       if (retval != STATUS_SUCCESS)
>                                                 TRACE_RET(chip, STATUS_FAIL);
> -                                       }
> +
>                                         switch_ddr = 0;
>                                         TRACE_GOTO(chip, Switch_Fail);
>                                 }
> @@ -3082,9 +2980,8 @@ MMC_UNLOCK_ENTRY:
>  #endif
>
>         temp = rtsx_readl(chip, RTSX_BIPR);
> -       if (temp & SD_WRITE_PROTECT) {
> +       if (temp & SD_WRITE_PROTECT)
>                 chip->card_wp |= SD_CARD;
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -3100,36 +2997,33 @@ int reset_sd_card(struct rtsx_chip *chip)
>         chip->capacity[chip->card2lun[SD_CARD]] = 0;
>
>         retval = enable_card_clock(chip, SD_CARD);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (chip->ignore_sd && CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip)) {
>                 if (chip->asic_code) {
>                         retval = sd_pull_ctl_enable(chip);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
> +
>                 } else {
>                         retval = rtsx_write_register(chip, FPGA_PULL_CTL,
>                                                      FPGA_SD_PULL_CTL_BIT | 0x20, 0);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
> +
>                 }
>                 retval = card_share_mode(chip, SD_CARD);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 chip->sd_io = 1;
>                 TRACE_RET(chip, STATUS_FAIL);
>         }
>
>         retval = sd_init_power(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (chip->sd_ctl & RESET_MMC_FIRST) {
>                 retval = reset_mmc(chip);
> @@ -3168,18 +3062,17 @@ int reset_sd_card(struct rtsx_chip *chip)
>         }
>
>         retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
> +
>         RTSX_WRITE_REG(chip, REG_SD_BYTE_CNT_L, 0xFF, 0);
>         RTSX_WRITE_REG(chip, REG_SD_BYTE_CNT_H, 0xFF, 2);
>
>         chip->capacity[chip->card2lun[SD_CARD]] = sd_card->capacity;
>
>         retval = sd_set_init_para(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         RTSX_DEBUGP("sd_card->sd_type = 0x%x\n", sd_card->sd_type);
>
> @@ -3205,33 +3098,29 @@ static int reset_mmc_only(struct rtsx_chip *chip)
>         chip->capacity[chip->card2lun[SD_CARD]] = sd_card->capacity = 0;
>
>         retval = enable_card_clock(chip, SD_CARD);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_init_power(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = reset_mmc(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
> +
>         RTSX_WRITE_REG(chip, REG_SD_BYTE_CNT_L, 0xFF, 0);
>         RTSX_WRITE_REG(chip, REG_SD_BYTE_CNT_H, 0xFF, 2);
>
>         chip->capacity[chip->card2lun[SD_CARD]] = sd_card->capacity;
>
>         retval = sd_set_init_para(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         RTSX_DEBUGP("In reset_mmc_only, sd_card->sd_type = 0x%x\n", sd_card->sd_type);
>
> @@ -3255,9 +3144,8 @@ static int wait_data_buf_ready(struct rtsx_chip *chip)
>
>                 retval = sd_send_cmd_get_rsp(chip, SEND_STATUS,
>                                 sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 if (sd_card->sd_data_buf_ready) {
>                         return sd_send_cmd_get_rsp(chip, SEND_STATUS,
> @@ -3277,19 +3165,18 @@ void sd_stop_seq_mode(struct rtsx_chip *chip)
>
>         if (sd_card->seq_mode) {
>                 retval = sd_switch_clock(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         return;
> -               }
>
>                 retval = sd_send_cmd_get_rsp(chip, STOP_TRANSMISSION, 0,
>                                 SD_RSP_TYPE_R1b, NULL, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         sd_set_err_code(chip, SD_STS_ERR);
> -               }
> +
>                 retval = sd_wait_state_data_ready(chip, 0x08, 1, 1000);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         sd_set_err_code(chip, SD_STS_ERR);
> -               }
> +
>                 sd_card->seq_mode = 0;
>
>                 rtsx_write_register(chip, RBCTL, RB_FLUSH, RB_FLUSH);
> @@ -3302,9 +3189,9 @@ static inline int sd_auto_tune_clock(struct rtsx_chip *chip)
>         int retval;
>
>         if (chip->asic_code) {
> -               if (sd_card->sd_clock > 30) {
> +               if (sd_card->sd_clock > 30)
>                         sd_card->sd_clock -= 20;
> -               }
> +
>         } else {
>                 switch (sd_card->sd_clock) {
>                 case CLK_200:
> @@ -3337,9 +3224,8 @@ static inline int sd_auto_tune_clock(struct rtsx_chip *chip)
>         }
>
>         retval = sd_switch_clock(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -3377,11 +3263,10 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
>                 }
>         }
>
> -       if (!CHK_SD_HCXC(sd_card) && !CHK_MMC_SECTOR_MODE(sd_card)) {
> +       if (!CHK_SD_HCXC(sd_card) && !CHK_MMC_SECTOR_MODE(sd_card))
>                 data_addr = start_sector << 9;
> -       } else {
> +       else
>                 data_addr = start_sector;
> -       }
>
>         sd_clr_err_code(chip);
>
> @@ -3436,21 +3321,20 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
>
>         rtsx_add_cmd(chip, WRITE_REG_CMD, CARD_DATA_SOURCE, 0x01, RING_BUFFER);
>
> -       if (CHK_MMC_8BIT(sd_card)) {
> +       if (CHK_MMC_8BIT(sd_card))
>                 rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_8);
> -       } else if (CHK_MMC_4BIT(sd_card) || CHK_SD(sd_card)) {
> +       else if (CHK_MMC_4BIT(sd_card) || CHK_SD(sd_card))
>                 rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_4);
> -       } else {
> +       else
>                 rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_1);
> -       }
>
>         if (sd_card->seq_mode) {
>                 cfg2 = SD_NO_CALCULATE_CRC7 | SD_CHECK_CRC16 | SD_NO_WAIT_BUSY_END |
>                                 SD_NO_CHECK_CRC7 | SD_RSP_LEN_0;
>                 if (CHECK_PID(chip, 0x5209)) {
> -                       if (!CHK_SD30_SPEED(sd_card)) {
> +                       if (!CHK_SD30_SPEED(sd_card))
>                                 cfg2 |= SD_NO_CHECK_WAIT_CRC_TO;
> -                       }
> +
>                 }
>                 rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG2, 0xFF, cfg2);
>
> @@ -3480,9 +3364,9 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
>                         cfg2 = SD_CALCULATE_CRC7 | SD_CHECK_CRC16 | SD_NO_WAIT_BUSY_END |
>                                         SD_CHECK_CRC7 | SD_RSP_LEN_6;
>                         if (CHECK_PID(chip, 0x5209)) {
> -                               if (!CHK_SD30_SPEED(sd_card)) {
> +                               if (!CHK_SD30_SPEED(sd_card))
>                                         cfg2 |= SD_NO_CHECK_WAIT_CRC_TO;
> -                               }
> +
>                         }
>                         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG2, 0xFF, cfg2);
>
> @@ -3523,9 +3407,9 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
>                         cfg2 = SD_NO_CALCULATE_CRC7 | SD_CHECK_CRC16 | SD_NO_WAIT_BUSY_END |
>                                         SD_NO_CHECK_CRC7 | SD_RSP_LEN_0;
>                         if (CHECK_PID(chip, 0x5209)) {
> -                               if (!CHK_SD30_SPEED(sd_card)) {
> +                               if (!CHK_SD30_SPEED(sd_card))
>                                         cfg2 |= SD_NO_CHECK_WAIT_CRC_TO;
> -                               }
> +
>                         }
>                         rtsx_add_cmd(chip, WRITE_REG_CMD, REG_SD_CFG2, 0xFF, cfg2);
>
> @@ -3550,11 +3434,10 @@ int sd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
>
>                 sd_card->seq_mode = 0;
>
> -               if (retval == -ETIMEDOUT) {
> +               if (retval == -ETIMEDOUT)
>                         err = STATUS_TIMEDOUT;
> -               } else {
> +               else
>                         err = STATUS_FAIL;
> -               }
>
>                 rtsx_read_register(chip, REG_SD_STAT1, &stat);
>                 rtsx_clear_sd_error(chip);
> @@ -3640,9 +3523,8 @@ int ext_sd_send_cmd_get_rsp(struct rtsx_chip *chip, u8 cmd_idx,
>
>         RTSX_DEBUGP("EXT SD/MMC CMD %d\n", cmd_idx);
>
> -       if (rsp_type == SD_RSP_TYPE_R1b) {
> +       if (rsp_type == SD_RSP_TYPE_R1b)
>                 timeout = 3000;
> -       }
>
>  RTY_SEND_CMD:
>
> @@ -3662,14 +3544,14 @@ RTY_SEND_CMD:
>         rtsx_add_cmd(chip, CHECK_REG_CMD, REG_SD_TRANSFER, SD_TRANSFER_END, SD_TRANSFER_END);
>
>         if (rsp_type == SD_RSP_TYPE_R2) {
> -               for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++) {
> +               for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++)
>                         rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
> -               }
> +
>                 stat_idx = 17;
>         } else if (rsp_type != SD_RSP_TYPE_R0) {
> -               for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++) {
> +               for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++)
>                         rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
> -               }
> +
>                 stat_idx = 6;
>         }
>         rtsx_add_cmd(chip, READ_REG_CMD, REG_SD_CMD5, 0, 0);
> @@ -3683,9 +3565,9 @@ RTY_SEND_CMD:
>
>                         if (rsp_type & SD_WAIT_BUSY_END) {
>                                 retval = sd_check_data0_status(chip);
> -                               if (retval != STATUS_SUCCESS) {
> +                               if (retval != STATUS_SUCCESS)
>                                         TRACE_RET(chip, retval);
> -                               }
> +
>                         } else {
>                                 sd_set_err_code(chip, SD_TO_ERR);
>                         }
> @@ -3693,9 +3575,8 @@ RTY_SEND_CMD:
>                 TRACE_RET(chip, STATUS_FAIL);
>         }
>
> -       if (rsp_type == SD_RSP_TYPE_R0) {
> +       if (rsp_type == SD_RSP_TYPE_R0)
>                 return STATUS_SUCCESS;
> -       }
>
>         ptr = rtsx_get_cmd_data(chip) + 1;
>
> @@ -3724,9 +3605,9 @@ RTY_SEND_CMD:
>         if ((cmd_idx == SELECT_CARD) || (cmd_idx == APP_CMD) ||
>                         (cmd_idx == SEND_STATUS) || (cmd_idx == STOP_TRANSMISSION)) {
>                 if ((cmd_idx != STOP_TRANSMISSION) && (special_check == 0)) {
> -                       if (ptr[1] & 0x80) {
> +                       if (ptr[1] & 0x80)
>                                 TRACE_RET(chip, STATUS_FAIL);
> -                       }
> +
>                 }
>  #ifdef SUPPORT_SD_LOCK
>                 if (ptr[1] & 0x7D)
> @@ -3736,26 +3617,24 @@ RTY_SEND_CMD:
>                 {
>                         TRACE_RET(chip, STATUS_FAIL);
>                 }
> -               if (ptr[2] & 0xF8) {
> +               if (ptr[2] & 0xF8)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 if (cmd_idx == SELECT_CARD) {
>                         if (rsp_type == SD_RSP_TYPE_R2) {
> -                               if ((ptr[3] & 0x1E) != 0x04) {
> +                               if ((ptr[3] & 0x1E) != 0x04)
>                                         TRACE_RET(chip, STATUS_FAIL);
> -                               }
> +
>                         } else if (rsp_type == SD_RSP_TYPE_R0) {
> -                               if ((ptr[3] & 0x1E) != 0x03) {
> +                               if ((ptr[3] & 0x1E) != 0x03)
>                                         TRACE_RET(chip, STATUS_FAIL);
> -                               }
> +
>                         }
>                 }
>         }
>
> -       if (rsp && rsp_len) {
> +       if (rsp && rsp_len)
>                 memcpy(rsp, ptr, rsp_len);
> -       }
>
>         return STATUS_SUCCESS;
>  }
> @@ -3765,29 +3644,27 @@ int ext_sd_get_rsp(struct rtsx_chip *chip, int len, u8 *rsp, u8 rsp_type)
>         int retval, rsp_len;
>         u16 reg_addr;
>
> -       if (rsp_type == SD_RSP_TYPE_R0) {
> +       if (rsp_type == SD_RSP_TYPE_R0)
>                 return STATUS_SUCCESS;
> -       }
>
>         rtsx_init_cmd(chip);
>
>         if (rsp_type == SD_RSP_TYPE_R2) {
> -               for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++) {
> +               for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++)
>                         rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0xFF, 0);
> -               }
> +
>                 rsp_len = 17;
>         } else if (rsp_type != SD_RSP_TYPE_R0) {
> -               for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++) {
> +               for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++)
>                         rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0xFF, 0);
> -               }
> +
>                 rsp_len = 6;
>         }
>         rtsx_add_cmd(chip, READ_REG_CMD, REG_SD_CMD5, 0xFF, 0);
>
>         retval = rtsx_send_cmd(chip, SD_CARD, 100);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (rsp) {
>                 int min_len = (rsp_len < len) ? rsp_len : len;
> @@ -3858,9 +3735,8 @@ int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         }
>
>         buf[5] = (1 == CHK_SD(sd_card)) ?  0x01 : 0x02;
> -       if (chip->card_wp & SD_CARD) {
> +       if (chip->card_wp & SD_CARD)
>                 buf[5] |= 0x80;
> -       }
>
>         buf[6] = (u8)(sd_card->sd_addr >> 16);
>         buf[7] = (u8)(sd_card->sd_addr >> 24);
> @@ -3875,9 +3751,8 @@ int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>
>  static inline int get_rsp_type(struct scsi_cmnd *srb, u8 *rsp_type, int *rsp_len)
>  {
> -       if (!rsp_type || !rsp_len) {
> +       if (!rsp_type || !rsp_len)
>                 return STATUS_FAIL;
> -       }
>
>         switch (srb->cmnd[10]) {
>         case 0x03:
> @@ -3927,9 +3802,8 @@ int sd_execute_no_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         }
>
>         retval = sd_switch_clock(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, TRANSPORT_FAILED);
> -       }
>
>         if (sd_card->pre_cmd_err) {
>                 sd_card->pre_cmd_err = 0;
> @@ -3938,12 +3812,11 @@ int sd_execute_no_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         }
>
>         cmd_idx = srb->cmnd[2] & 0x3F;
> -       if (srb->cmnd[1] & 0x02) {
> +       if (srb->cmnd[1] & 0x02)
>                 standby = 1;
> -       }
> -       if (srb->cmnd[1] & 0x01) {
> +
> +       if (srb->cmnd[1] & 0x01)
>                 acmd = 1;
> -       }
>
>         arg = ((u32)srb->cmnd[3] << 24) | ((u32)srb->cmnd[4] << 16) |
>                 ((u32)srb->cmnd[5] << 8) | srb->cmnd[6];
> @@ -3956,64 +3829,58 @@ int sd_execute_no_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         sd_card->last_rsp_type = rsp_type;
>
>         retval = sd_switch_clock(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, TRANSPORT_FAILED);
> -       }
>
>  #ifdef SUPPORT_SD_LOCK
>         if ((sd_card->sd_lock_status & SD_LOCK_1BIT_MODE) == 0) {
>                 if (CHK_MMC_8BIT(sd_card)) {
>                         retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_8);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, TRANSPORT_FAILED);
> -                       }
> +
>                 } else if (CHK_SD(sd_card) || CHK_MMC_4BIT(sd_card)) {
>                         retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_4);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, TRANSPORT_FAILED);
> -                       }
> +
>                 }
>         }
>  #else
>         retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_4);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, TRANSPORT_FAILED);
> -       }
> +
>  #endif
>
>         if (standby) {
>                 retval = sd_select_card(chip, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
> -               }
>         }
>
>         if (acmd) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr,
>                                 SD_RSP_TYPE_R1, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
> -               }
>         }
>
>         retval = ext_sd_send_cmd_get_rsp(chip, cmd_idx, arg, rsp_type,
>                         sd_card->rsp, rsp_len, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
> -       }
>
>         if (standby) {
>                 retval = sd_select_card(chip, 1);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
> -               }
>         }
>
>  #ifdef SUPPORT_SD_LOCK
>         retval = sd_update_lock_status(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
> -       }
>  #endif
>
>         scsi_set_resid(srb, 0);
> @@ -4024,9 +3891,8 @@ SD_Execute_Cmd_Failed:
>         set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
>         release_sd_card(chip);
>         do_reset_sd_card(chip);
> -       if (!(chip->card_ready & SD_CARD)) {
> +       if (!(chip->card_ready & SD_CARD))
>                 set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
> -       }
>
>         TRACE_RET(chip, TRANSPORT_FAILED);
>  }
> @@ -4053,20 +3919,18 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         }
>
>         retval = sd_switch_clock(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, TRANSPORT_FAILED);
> -       }
>
>         cmd_idx = srb->cmnd[2] & 0x3F;
> -       if (srb->cmnd[1] & 0x04) {
> +       if (srb->cmnd[1] & 0x04)
>                 send_cmd12 = 1;
> -       }
> -       if (srb->cmnd[1] & 0x02) {
> +
> +       if (srb->cmnd[1] & 0x02)
>                 standby = 1;
> -       }
> -       if (srb->cmnd[1] & 0x01) {
> +
> +       if (srb->cmnd[1] & 0x01)
>                 acmd = 1;
> -       }
>
>         data_len = ((u32)srb->cmnd[7] << 16) | ((u32)srb->cmnd[8] << 8) | srb->cmnd[9];
>
> @@ -4078,19 +3942,18 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         sd_card->last_rsp_type = rsp_type;
>
>         retval = sd_switch_clock(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, TRANSPORT_FAILED);
> -       }
>
>  #ifdef SUPPORT_SD_LOCK
>         if ((sd_card->sd_lock_status & SD_LOCK_1BIT_MODE) == 0) {
> -               if (CHK_MMC_8BIT(sd_card)) {
> +               if (CHK_MMC_8BIT(sd_card))
>                         bus_width = SD_BUS_WIDTH_8;
> -               } else if (CHK_SD(sd_card) || CHK_MMC_4BIT(sd_card)) {
> +               else if (CHK_SD(sd_card) || CHK_MMC_4BIT(sd_card))
>                         bus_width = SD_BUS_WIDTH_4;
> -               } else {
> +               else
>                         bus_width = SD_BUS_WIDTH_1;
> -               }
> +
>         } else {
>                 bus_width = SD_BUS_WIDTH_4;
>         }
> @@ -4102,24 +3965,21 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         if (data_len < 512) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, data_len,
>                                 SD_RSP_TYPE_R1, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -               }
>         }
>
>         if (standby) {
>                 retval = sd_select_card(chip, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -               }
>         }
>
>         if (acmd) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr,
>                                 SD_RSP_TYPE_R1, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -               }
>         }
>
>         if (data_len <= 512) {
> @@ -4138,9 +3998,8 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>                 cmd[4] = srb->cmnd[6];
>
>                 buf = kmalloc(data_len, GFP_KERNEL);
> -               if (buf == NULL) {
> +               if (buf == NULL)
>                         TRACE_RET(chip, TRANSPORT_ERROR);
> -               }
>
>                 retval = sd_read_data(chip, SD_TM_NORMAL_READ, cmd, 5, byte_cnt,
>                                        blk_cnt, bus_width, buf, data_len, 2000);
> @@ -4195,56 +4054,48 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         }
>
>         retval = ext_sd_get_rsp(chip, rsp_len, sd_card->rsp, rsp_type);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -       }
>
>         if (standby) {
>                 retval = sd_select_card(chip, 1);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -               }
>         }
>
>         if (send_cmd12) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, STOP_TRANSMISSION,
>                                 0, SD_RSP_TYPE_R1b, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -               }
>         }
>
>         if (data_len < 512) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, 0x200,
>                                 SD_RSP_TYPE_R1, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -               }
>
>                 retval = rtsx_write_register(chip, SD_BYTE_CNT_H, 0xFF, 0x02);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -               }
> +
>                 retval = rtsx_write_register(chip, SD_BYTE_CNT_L, 0xFF, 0x00);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -               }
>         }
>
> -       if ((srb->cmnd[1] & 0x02) || (srb->cmnd[1] & 0x04)) {
> +       if ((srb->cmnd[1] & 0x02) || (srb->cmnd[1] & 0x04))
>                 cmd13_checkbit = 1;
> -       }
>
>         for (i = 0; i < 3; i++) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, SEND_STATUS, sd_card->sd_addr,
>                         SD_RSP_TYPE_R1, NULL, 0, cmd13_checkbit);
> -               if (retval == STATUS_SUCCESS) {
> +               if (retval == STATUS_SUCCESS)
>                         break;
> -               }
>         }
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
> -       }
>
>         scsi_set_resid(srb, 0);
>         return TRANSPORT_GOOD;
> @@ -4252,14 +4103,13 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>  SD_Execute_Read_Cmd_Failed:
>         sd_card->pre_cmd_err = 1;
>         set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
> -       if (read_err) {
> +       if (read_err)
>                 set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
> -       }
> +
>         release_sd_card(chip);
>         do_reset_sd_card(chip);
> -       if (!(chip->card_ready & SD_CARD)) {
> +       if (!(chip->card_ready & SD_CARD))
>                 set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
> -       }
>
>         TRACE_RET(chip, TRANSPORT_FAILED);
>  }
> @@ -4291,20 +4141,18 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         }
>
>         retval = sd_switch_clock(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, TRANSPORT_FAILED);
> -       }
>
>         cmd_idx = srb->cmnd[2] & 0x3F;
> -       if (srb->cmnd[1] & 0x04) {
> +       if (srb->cmnd[1] & 0x04)
>                 send_cmd12 = 1;
> -       }
> -       if (srb->cmnd[1] & 0x02) {
> +
> +       if (srb->cmnd[1] & 0x02)
>                 standby = 1;
> -       }
> -       if (srb->cmnd[1] & 0x01) {
> +
> +       if (srb->cmnd[1] & 0x01)
>                 acmd = 1;
> -       }
>
>         data_len = ((u32)srb->cmnd[7] << 16) | ((u32)srb->cmnd[8] << 8) | srb->cmnd[9];
>         arg = ((u32)srb->cmnd[3] << 24) | ((u32)srb->cmnd[4] << 16) |
> @@ -4325,75 +4173,68 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         sd_card->last_rsp_type = rsp_type;
>
>         retval = sd_switch_clock(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, TRANSPORT_FAILED);
> -       }
>
>  #ifdef SUPPORT_SD_LOCK
>         if ((sd_card->sd_lock_status & SD_LOCK_1BIT_MODE) == 0) {
>                 if (CHK_MMC_8BIT(sd_card)) {
>                         retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_8);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, TRANSPORT_FAILED);
> -                       }
> +
>                 } else if (CHK_SD(sd_card) || CHK_MMC_4BIT(sd_card)) {
>                         retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_4);
> -                       if (retval != STATUS_SUCCESS) {
> +                       if (retval != STATUS_SUCCESS)
>                                 TRACE_RET(chip, TRANSPORT_FAILED);
> -                       }
> +
>                 }
>         }
>  #else
>         retval = rtsx_write_register(chip, REG_SD_CFG1, 0x03, SD_BUS_WIDTH_4);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, TRANSPORT_FAILED);
> -       }
> +
>  #endif
>
>         if (data_len < 512) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, data_len,
>                                 SD_RSP_TYPE_R1, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -               }
>         }
>
>         if (standby) {
>                 retval = sd_select_card(chip, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -               }
>         }
>
>         if (acmd) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr,
>                                 SD_RSP_TYPE_R1, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -               }
>         }
>
>         retval = ext_sd_send_cmd_get_rsp(chip, cmd_idx, arg, rsp_type,
>                         sd_card->rsp, rsp_len, 0);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -       }
>
>         if (data_len <= 512) {
>                 u16 i;
>                 u8 *buf;
>
>                 buf = kmalloc(data_len, GFP_KERNEL);
> -               if (buf == NULL) {
> +               if (buf == NULL)
>                         TRACE_RET(chip, TRANSPORT_ERROR);
> -               }
>
>                 rtsx_stor_get_xfer_buf(buf, data_len, srb);
>
>  #ifdef SUPPORT_SD_LOCK
> -               if (cmd_idx == LOCK_UNLOCK) {
> +               if (cmd_idx == LOCK_UNLOCK)
>                         lock_cmd_type = buf[0] & 0x0F;
> -               }
>  #endif
>
>                 if (data_len > 256) {
> @@ -4485,11 +4326,11 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>                 }
>
>                 rtsx_init_cmd(chip);
> -               if (CHECK_PID(chip, 0x5209)) {
> +               if (CHECK_PID(chip, 0x5209))
>                         rtsx_add_cmd(chip, CHECK_REG_CMD, SD_BUS_STAT, SD_DAT0_STATUS, SD_DAT0_STATUS);
> -               } else {
> +               else
>                         rtsx_add_cmd(chip, CHECK_REG_CMD, 0xFD30, 0x02, 0x02);
> -               }
> +
>                 rtsx_send_cmd(chip, SD_CARD, 250);
>
>                 retval = sd_update_lock_status(chip);
> @@ -4502,61 +4343,54 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>
>         if (standby) {
>                 retval = sd_select_card(chip, 1);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -               }
>         }
>
>         if (send_cmd12) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, STOP_TRANSMISSION,
>                                 0, SD_RSP_TYPE_R1b, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -               }
>         }
>
>         if (data_len < 512) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, SET_BLOCKLEN, 0x200,
>                                 SD_RSP_TYPE_R1, NULL, 0, 0);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -               }
>
>                 retval = rtsx_write_register(chip, SD_BYTE_CNT_H, 0xFF, 0x02);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -               }
> +
>                 rtsx_write_register(chip, SD_BYTE_CNT_L, 0xFF, 0x00);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -               }
> +
>         }
>
> -       if ((srb->cmnd[1] & 0x02) || (srb->cmnd[1] & 0x04)) {
> +       if ((srb->cmnd[1] & 0x02) || (srb->cmnd[1] & 0x04))
>                 cmd13_checkbit = 1;
> -       }
>
>         for (i = 0; i < 3; i++) {
>                 retval = ext_sd_send_cmd_get_rsp(chip, SEND_STATUS, sd_card->sd_addr,
>                         SD_RSP_TYPE_R1, NULL, 0, cmd13_checkbit);
> -               if (retval == STATUS_SUCCESS) {
> +               if (retval == STATUS_SUCCESS)
>                         break;
> -               }
>         }
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
> -       }
>
>  #ifdef SUPPORT_SD_LOCK
>         if (cmd_idx == LOCK_UNLOCK) {
>                 if (!lock_cmd_fail) {
>                         RTSX_DEBUGP("lock_cmd_type = 0x%x\n", lock_cmd_type);
> -                       if (lock_cmd_type & SD_CLR_PWD) {
> +                       if (lock_cmd_type & SD_CLR_PWD)
>                                 sd_card->sd_lock_status &= ~SD_PWD_EXIST;
> -                       }
> -                       if (lock_cmd_type & SD_SET_PWD) {
> +
> +                       if (lock_cmd_type & SD_SET_PWD)
>                                 sd_card->sd_lock_status |= SD_PWD_EXIST;
> -                       }
>                 }
>
>                 RTSX_DEBUGP("sd_lock_state = 0x%x, sd_card->sd_lock_status = 0x%x\n",
> @@ -4593,14 +4427,13 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>  SD_Execute_Write_Cmd_Failed:
>         sd_card->pre_cmd_err = 1;
>         set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
> -       if (write_err) {
> +       if (write_err)
>                 set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
> -       }
> +
>         release_sd_card(chip);
>         do_reset_sd_card(chip);
> -       if (!(chip->card_ready & SD_CARD)) {
> +       if (!(chip->card_ready & SD_CARD))
>                 set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
> -       }
>
>         TRACE_RET(chip, TRANSPORT_FAILED);
>  }
> @@ -4670,9 +4503,8 @@ int sd_hw_rst(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>         switch (srb->cmnd[1] & 0x0F) {
>         case 0:
>  #ifdef SUPPORT_SD_LOCK
> -               if (0x64 == srb->cmnd[9]) {
> +               if (0x64 == srb->cmnd[9])
>                         sd_card->sd_lock_status |= SD_SDR_RST;
> -               }
>  #endif
>                 retval = reset_sd_card(chip);
>                 if (retval != STATUS_SUCCESS) {
> @@ -4723,26 +4555,23 @@ int sd_power_off_card3v3(struct rtsx_chip *chip)
>         int retval;
>
>         retval = disable_card_clock(chip, SD_CARD);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         RTSX_WRITE_REG(chip, CARD_OE, SD_OUTPUT_EN, 0);
>
>         if (!chip->ft2_fast_mode) {
>                 retval = card_power_off(chip, SD_CARD);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
>                 wait_timeout(50);
>         }
>
>         if (chip->asic_code) {
>                 retval = sd_pull_ctl_disable(chip);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>         } else {
>                 RTSX_WRITE_REG(chip, FPGA_PULL_CTL,
>                         FPGA_SD_PULL_CTL_BIT | 0x20, FPGA_SD_PULL_CTL_BIT);
> @@ -4774,19 +4603,16 @@ int release_sd_card(struct rtsx_chip *chip)
>         memset(sd_card->raw_scr, 0, 8);
>
>         retval = sd_power_off_card3v3(chip);
> -       if (retval != STATUS_SUCCESS) {
> +       if (retval != STATUS_SUCCESS)
>                 TRACE_RET(chip, STATUS_FAIL);
> -       }
>
>         if (CHECK_PID(chip, 0x5209)) {
>                 retval = sd_change_bank_voltage(chip, SD_IO_3V3);
> -               if (retval != STATUS_SUCCESS) {
> +               if (retval != STATUS_SUCCESS)
>                         TRACE_RET(chip, STATUS_FAIL);
> -               }
>
> -               if (CHK_SD30_SPEED(sd_card)) {
> +               if (CHK_SD30_SPEED(sd_card))
>                         RTSX_WRITE_REG(chip, SD30_DRIVE_SEL, 0x07, chip->sd30_drive_sel_3v3);
> -               }
>
>                 RTSX_WRITE_REG(chip, OCPPARA2, SD_OCP_THD_MASK, chip->sd_400mA_ocp_thd);
>         }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
